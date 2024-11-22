//
//  NotificationRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Class responsible for managing notification-related operations.
///
/// `NotificationsRepositoryImpl` implements the `NotificationsRepository` protocol, providing methods for
/// uploading, fetching, marking notifications as read, and deleting notifications. It interacts with the
/// `NotificationsDataSource` to retrieve raw data, and uses a `NotificationMapper` to map data transfer objects
/// (DTOs) to business objects (BOs) that can be used by the application.
internal class NotificationsRepositoryImpl: NotificationsRepository {
    
    private let notificationsDataSource: NotificationsDataSource
    private let notificationMapper: NotificationMapper
    
    /// Initializes an instance of `NotificationsRepositoryImpl`.
    ///
    /// - Parameters:
    ///   - notificationsDataSource: The data source used to fetch and manipulate notifications in the raw data layer.
    ///   - notificationMapper: The mapper used to convert `NotificationDTO` objects into `NotificationBO` objects.
    init(
        notificationsDataSource: NotificationsDataSource,
        notificationMapper: NotificationMapper
    ) {
        self.notificationsDataSource = notificationsDataSource
        self.notificationMapper = notificationMapper
    }
        
    /// Fetches notifications for a specific user asynchronously.
    ///
    /// This method fetches the notifications associated with a specific user, identified by their `userId`.
    /// The method maps each notification from a `NotificationDTO` to a `NotificationBO` using the `notificationMapper`.
    ///
    /// - Parameter userId: The ID of the user whose notifications are to be fetched.
    /// - Returns: An array of `NotificationBO` objects representing the user's notifications.
    /// - Throws: An error if the fetch operation fails, or if the mapping process encounters an issue.
    func fetchUserNotifications(userId: String) async throws -> [NotificationBO] {
        do {
            // Fetch the user's notifications from the data source
            let notificationsDTO = try await notificationsDataSource.fetchUserNotifications(uid: userId)
            return notificationsDTO.map { notificationMapper.map($0) }
        } catch {
            print(error.localizedDescription)
            throw NotificationsRepositoryError.userNotificationsFetchFailed(message: "Failed to fetch notifications for userId \(userId): \(error.localizedDescription)")
        }
    }

    /// Marks a specific notification as read.
    ///
    /// This method marks a notification as read by sending the update request to the data source.
    ///
    /// - Parameter notificationId: The ID of the notification to mark as read.
    /// - Returns: A boolean indicating whether the operation was successful (`true` if successful, `false` otherwise).
    /// - Throws: An error if the operation fails to mark the notification as read.
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
    /// This method deletes a notification by sending a delete request to the data source.
    ///
    /// - Parameter notificationId: The ID of the notification to be deleted.
    /// - Returns: A boolean indicating whether the operation was successful (`true` if successful, `false` otherwise).
    /// - Throws: An error if the operation fails to delete the notification.
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
