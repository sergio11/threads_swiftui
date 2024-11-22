//
//  FirestoreNotificationsDataSourceImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Firestore implementation of `NotificationsDataSource`.
struct FirestoreNotificationsDataSourceImpl: NotificationsDataSource {
    
    private let notificationsCollection = "threads_notifications"
    private let db = Firestore.firestore()

    /// Fetches all notifications from Firestore.
    /// - Returns: An array of `NotificationDTO` objects.
    func fetchNotifications() async throws -> [NotificationDTO] {
        do {
            let snapshot = try await db
                .collection(notificationsCollection)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            // Map Firestore documents to `NotificationDTO`
            let notifications = snapshot.documents.compactMap { document in
                try? document.data(as: NotificationDTO.self)
            }
            
            if notifications.isEmpty {
                throw NotificationsDataSourceError.fetchNotificationsFailed
            }
            
            return notifications
        } catch {
            print("Error fetching notifications: \(error.localizedDescription)")
            throw NotificationsDataSourceError.fetchNotificationsFailed
        }
    }

    /// Fetches notifications for a specific user.
    /// - Parameter uid: The user ID whose notifications are to be fetched.
    /// - Returns: An array of `NotificationDTO` objects, sorted by timestamp.
    func fetchUserNotifications(uid: String) async throws -> [NotificationDTO] {
        do {
            let snapshot = try await db
                .collection(notificationsCollection)
                .whereField("userId", isEqualTo: uid)
                .getDocuments()
            
            let notifications = snapshot.documents.compactMap { document in
                try? document.data(as: NotificationDTO.self)
            }
            
            if notifications.isEmpty {
                throw NotificationsDataSourceError.fetchUserNotificationsFailed
            }
            
            // Sort notifications by timestamp in descending order
            return notifications.sorted { $0.timestamp > $1.timestamp }
        } catch {
            print("Error fetching user's notifications: \(error.localizedDescription)")
            throw NotificationsDataSourceError.fetchUserNotificationsFailed
        }
    }

    /// Fetches a notification by its ID.
    /// - Parameter notificationId: The ID of the notification to fetch.
    /// - Returns: A `NotificationDTO` representing the notification.
    private func getNotificationById(notificationId: String) async throws -> NotificationDTO {
        do {
            let documentSnapshot = try await db
                .collection(notificationsCollection)
                .document(notificationId)
                .getDocument()
            
            guard let notification = try? documentSnapshot.data(as: NotificationDTO.self) else {
                print("Notification not found with ID: \(notificationId)")
                throw NotificationsDataSourceError.notificationNotFound
            }
            return notification
        } catch {
            print("Error getting notification by ID: \(error.localizedDescription)")
            throw NotificationsDataSourceError.notificationNotFound
        }
    }
    
    /// Marks a specific notification as read.
    /// - Parameter notificationId: The ID of the notification to mark as read.
    /// - Throws: An error if the operation fails.
    /// - Returns: A boolean indicating if the operation was successful.
    func markNotificationAsRead(notificationId: String) async throws -> Bool {
        let notificationRef = db.collection(notificationsCollection).document(notificationId)

        do {
            let notificationSnapshot = try await notificationRef.getDocument()
            guard var notification = try? notificationSnapshot.data(as: NotificationDTO.self) else {
                print("Notification not found")
                throw NotificationsDataSourceError.notificationNotFound
            }
            notification.isRead = true
            try await notificationRef.updateData([
                "isRead": true
            ])
            return true
        } catch {
            print("Error marking notification as read: \(error.localizedDescription)")
            throw NotificationsDataSourceError.markAsReadFailed
        }
    }

    /// Deletes a specific notification.
    /// - Parameter notificationId: The ID of the notification to be deleted.
    /// - Throws: An error if the operation fails.
    /// - Returns: A boolean indicating if the operation was successful.
    func deleteNotification(notificationId: String) async throws -> Bool {
        let notificationRef = db.collection(notificationsCollection).document(notificationId)
        
        do {
            try await notificationRef.delete()
            return true
        } catch {
            print("Error deleting notification: \(error.localizedDescription)")
            throw NotificationsDataSourceError.deleteNotificationFailed
        }
    }
}
