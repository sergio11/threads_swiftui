//
//  FetchNotificationsUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

enum FetchNotificationsError: Error {
    case fetchFailed
    case markAsReadFailed
}

/// An entity responsible for fetching notifications and marking them as read.
struct FetchNotificationsUseCase {
    let notificationsRepository: NotificationsRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the fetch operation for notifications and marks them as read asynchronously.
    /// - Returns: A list of `NotificationBO` objects representing the notifications for the current user.
    /// - Throws: An error if the fetch or mark as read operations fail.
    func execute() async throws -> [NotificationBO] {
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw FetchNotificationsError.fetchFailed
        }
        
        do {
            let notifications = try await notificationsRepository.fetchUserNotifications(userId: userId)
            for notification in notifications {
                let success = try await notificationsRepository.markNotificationAsRead(notificationId: notification.id)
                if !success {
                    throw FetchNotificationsError.markAsReadFailed
                }
            }
            return notifications
        } catch {
            throw FetchNotificationsError.fetchFailed
        }
    }
}
