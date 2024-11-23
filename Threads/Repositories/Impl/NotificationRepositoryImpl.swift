//
//  NotificationRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation


/// A concrete implementation of the `NotificationsRepository` protocol.
/// Responsible for handling operations related to fetching, marking, and deleting user notifications.
///
/// This class interacts with data sources and repositories to fetch user notifications,
/// mark them as read, and delete them. It utilizes local caching for user data to improve performance
/// by reducing unnecessary fetch calls for user information. It also uses a notification mapper to convert
/// the data transfer objects (DTOs) into business objects (BOs) for further processing.
internal class NotificationsRepositoryImpl: NotificationsRepository {
    
    // MARK: - Dependencies
    
    private let notificationsDataSource: NotificationsDataSource
    private let notificationMapper: NotificationMapper
    private let userDataSource: UserDataSource
    private let authenticationRepository: AuthenticationRepository
    
    /// Initializes an instance of `NotificationsRepositoryImpl`.
    /// - Parameters:
    ///   - notificationsDataSource: The data source used to fetch notifications from the backend.
    ///   - notificationMapper: The mapper used to convert `NotificationDTO` to `NotificationBO`.
    ///   - userDataSource: The data source used to fetch user details.
    ///   - authenticationRepository: The repository used to fetch the current authenticated user ID.
    init(
        notificationsDataSource: NotificationsDataSource,
        notificationMapper: NotificationMapper,
        userDataSource: UserDataSource,
        authenticationRepository: AuthenticationRepository
    ) {
        self.notificationsDataSource = notificationsDataSource
        self.notificationMapper = notificationMapper
        self.userDataSource = userDataSource
        self.authenticationRepository = authenticationRepository
    }
    
    // MARK: - Public Methods
    
    /// Fetches a list of notifications for a specific user.
    ///
    /// - Parameters:
    ///   - userId: The user ID for which to fetch notifications.
    /// - Returns: An array of `NotificationBO` representing the user's notifications.
    /// - Throws: `NotificationsRepositoryError.userNotificationsFetchFailed` if fetching the notifications fails.
    func fetchUserNotifications(userId: String) async throws -> [NotificationBO] {
        do {
            guard let authUserId = try await self.authenticationRepository.getCurrentUserId() else {
                throw NotificationsRepositoryError.unknown(message: "Invalid auth user id")
            }
            
            // Fetch notifications from the data source
            let notificationsDTO = try await notificationsDataSource.fetchUserNotifications(uid: userId)
            
            // Local cache for user data to avoid duplicate fetches
            var userCache: [String: UserDTO] = [:]
            var notificationsBO = [NotificationBO]()
            
            for notificationDTO in notificationsDTO {
                do {
                    // Fetch the user who generated the notification, or use the cache if available
                    let ownerUserDTO: UserDTO
                    if let cachedOwnerUser = userCache[notificationDTO.byUserId] {
                        ownerUserDTO = cachedOwnerUser
                    } else {
                        ownerUserDTO = try await userDataSource.getUserById(userId: notificationDTO.byUserId)
                        userCache[notificationDTO.byUserId] = ownerUserDTO
                    }
                    
                    // Fetch the user who owns the notification, or use the cache if available
                    let userDTO: UserDTO
                    if let cachedUser = userCache[notificationDTO.ownerUserId] {
                        userDTO = cachedUser
                    } else {
                        userDTO = try await userDataSource.getUserById(userId: notificationDTO.ownerUserId)
                        userCache[notificationDTO.ownerUserId] = userDTO
                    }
                    
                    // Map the notification and append to the result list
                    notificationsBO.append(
                        notificationMapper.map(
                            NotificationDataMapper(
                                notificationDTO: notificationDTO,
                                notificationUserDTO: userDTO,
                                notificationOwnerUserDTO: ownerUserDTO,
                                authUserId: authUserId
                            )
                        )
                    )
                } catch {
                    print("Error fetching user for notification \(notificationDTO.id): \(error.localizedDescription)")
                }
            }
            
            return notificationsBO
        } catch {
            print(error.localizedDescription)
            throw NotificationsRepositoryError.userNotificationsFetchFailed(
                message: "Failed to fetch notifications for userId \(userId): \(error.localizedDescription)"
            )
        }
    }

    /// Marks a specific notification as read.
    ///
    /// - Parameters:
    ///   - notificationId: The ID of the notification to be marked as read.
    /// - Returns: A boolean indicating whether the operation was successful.
    /// - Throws: `NotificationsRepositoryError.markAsReadFailed` if the operation fails.
    func markNotificationAsRead(notificationId: String) async throws -> Bool {
        do {
            // Call the data source to mark the notification as read
            let success = try await notificationsDataSource.markNotificationAsRead(notificationId: notificationId)
            return success
        } catch {
            print(error.localizedDescription)
            throw NotificationsRepositoryError.markAsReadFailed(message: "Failed to mark notification as read: \(error.localizedDescription)")
        }
    }
    
    /// Deletes a specific notification.
    ///
    /// - Parameters:
    ///   - notificationId: The ID of the notification to be deleted.
    /// - Returns: A boolean indicating whether the operation was successful.
    /// - Throws: `NotificationsRepositoryError.deleteNotificationFailed` if the operation fails.
    func deleteNotification(notificationId: String) async throws -> Bool {
        do {
            // Call the data source to delete the notification
            let success = try await notificationsDataSource.deleteNotification(notificationId: notificationId)
            return success
        } catch {
            print(error.localizedDescription)
            throw NotificationsRepositoryError.deleteNotificationFailed(message: "Failed to delete notification: \(error.localizedDescription)")
        }
    }
}
