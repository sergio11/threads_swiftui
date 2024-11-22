//
//  NotificationsRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Enum representing errors that can occur in the `NotificationsRepository`.
enum NotificationsRepositoryError: Error {
    case userNotificationsFetchFailed(message: String) // Error when fetching a user's notifications fails
    case markAsReadFailed(message: String)      // Error when marking a notification as read fails
    case deleteNotificationFailed(message: String)  // Error when deleting a notification fails
    case unknown(message: String)               // Generic error for other unspecified failures
}

/// Protocol defining operations for managing notifications.
protocol NotificationsRepository {
    
    /// Fetches notifications for a specific user asynchronously.
    /// - Parameter userId: The ID of the user whose notifications to fetch.
    /// - Returns: An array of `NotificationBO` objects.
    /// - Throws: An error if the operation fails.
    func fetchUserNotifications(userId: String) async throws -> [NotificationBO]
    
    /// Marks a specific notification as read asynchronously.
    /// - Parameter notificationId: The ID of the notification to mark as read.
    /// - Returns: A boolean indicating if the operation was successful.
    /// - Throws: An error if the operation fails.
    func markNotificationAsRead(notificationId: String) async throws -> Bool
    
    /// Deletes a specific notification asynchronously.
    /// - Parameter notificationId: The ID of the notification to be deleted.
    /// - Returns: A boolean indicating if the operation was successful.
    /// - Throws: An error if the operation fails.
    func deleteNotification(notificationId: String) async throws -> Bool
}
