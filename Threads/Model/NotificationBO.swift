//
//  NotificationBO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Represents the type of notification event.
enum NotificationType {
    case follow          // Notification for being followed by another user.
    case repost          // Notification for a thread being reposted.
    case like            // Notification for a thread being liked.
    case comment         // Notification for a thread being commented on.
    
    /// Initializes a `NotificationType` from a string.
    /// - Parameter rawValue: The string representation of the notification type.
    /// - Throws: An error if the string does not match any notification type.
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "follow":
            self = .follow
        case "repost":
            self = .repost
        case "like":
            self = .like
        case "comment":
            self = .comment
        default:
            self = .follow
        }
    }
}

/// Business Object representing a Notification.
struct NotificationBO: Identifiable {
    /// Unique identifier for the notification.
    let id: String
    
    /// Title of the notification
    let title: String
    
    /// The  user who owns this notification.
    let ownerUser: UserBO
    
    /// The  user who triggered the notification event.
    let byUser: UserBO
    
    /// The type of the notification.
    let type: NotificationType
    
    /// Detailed message about the notification event.
    let message: String
    
    /// Timestamp when the notification was created.
    let timestamp: Date
    
    /// Boolean flag indicating if the notification has been read.
    var isRead: Bool
}
