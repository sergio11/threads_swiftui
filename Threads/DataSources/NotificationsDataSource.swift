//
//  NotificationsDataSource.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

// Enum representing errors that can occur in the `NotificationsDataSource`.
enum NotificationsDataSourceError: Error {
    /// Error indicating that the notification was not found.
    case notificationNotFound
    /// Error indicating that fetching notifications for a specific user failed.
    case fetchUserNotificationsFailed
    /// Error indicating that the notification mark-as-read operation failed.
    case markAsReadFailed
    /// Error indicating that deleting a notification failed.
    case deleteNotificationFailed
}

// Protocol defining data source operations for notifications.
protocol NotificationsDataSource {
    
    /// Fetches notifications for a specific user.
    /// - Parameter uid: The user ID whose notifications are to be fetched.
    /// - Returns: An array of `NotificationDTO` objects.
    /// - Throws: An error if fetching fails.
    func fetchUserNotifications(uid: String) async throws -> [NotificationDTO]
    
    /// Marks a specific notification as read.
    /// - Parameter notificationId: The ID of the notification to mark as read.
    /// - Throws: An error if the operation fails.
    /// - Returns: A boolean indicating if the operation was successful.
    func markNotificationAsRead(notificationId: String) async throws -> Bool
    
    /// Deletes a specific notification.
    /// - Parameter notificationId: The ID of the notification to be deleted.
    /// - Throws: An error if the operation fails.
    /// - Returns: A boolean indicating if the operation was successful.
    func deleteNotification(notificationId: String) async throws -> Bool
}

