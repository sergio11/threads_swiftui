//
//  NotificationBO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Business Object representing a Notification.
struct NotificationBO {
    let id: String
    let userId: String
    let message: String
    let timestamp: Date
    var read: Bool
}
