//
//  NotificationDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

struct NotificationDTO: Decodable, Hashable {
    let id: String
    let title: String
    let message: String
    let userId: String
    let timestamp: Date
    var isRead: Bool
}
