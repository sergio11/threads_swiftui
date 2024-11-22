//
//  NotificationMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

class NotificationMapper: Mapper {
    
    typealias Input = NotificationDTO
    typealias Output = NotificationBO
    
    func map(_ input: NotificationDTO) -> NotificationBO {
        return NotificationBO(
            id: input.id,
            userId: input.userId,
            message: input.message,
            timestamp: input.timestamp,
            read: input.isRead
        )
    }
}
