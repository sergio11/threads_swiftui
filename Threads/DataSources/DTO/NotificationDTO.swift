//
//  NotificationDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Data Transfer Object (DTO) for notifications.
struct NotificationDTO: Decodable, Hashable {
    /// Unique identifier for the notification.
    let id: String
    
    /// Title of the notification
    let title: String
    
    /// Detailed message about the notification event.
    let message: String
    
    /// The ID of the user who owns this notification.
    let ownerUserId: String
    
    /// The ID of the user who triggered the notification event.
    let byUserId: String
    
    /// The type of the notification
    let type: String
    
    /// Timestamp when the notification was created.
    let timestamp: Date
    
    /// Boolean flag indicating if the notification has been read.
    var isRead: Bool
}
