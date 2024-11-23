//
//  NotificationMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// A class responsible for mapping `NotificationDataMapper` (which contains DTOs) to `NotificationBO` (Business Object).
/// This mapper converts the raw data from data transfer objects (DTOs) into the business objects (BOs) used by the application.
///
/// It also maps related user information by utilizing a `UserMapper` to convert `UserDTO` to `UserBO` objects for both the owner and the actor of the notification.
class NotificationMapper: Mapper {
    
    // MARK: - Type Aliases
    
    typealias Input = NotificationDataMapper
    typealias Output = NotificationBO
    
    // MARK: - Dependencies
    
    private let userMapper: UserMapper
    
    /// Initializes an instance of `NotificationMapper`.
    /// - Parameter userMapper: The `UserMapper` used to map user-related data objects to business objects.
    init(userMapper: UserMapper) {
        self.userMapper = userMapper
    }
    
    /// Maps a `NotificationDataMapper` (which includes `NotificationDTO` and user DTOs) to a `NotificationBO` (Business Object).
    ///
    /// - Parameters:
    ///   - input: The `NotificationDataMapper` object that contains all the data needed for the notification.
    /// - Returns: A `NotificationBO` object representing the mapped notification.
    func map(_ input: NotificationDataMapper) -> NotificationBO {
        return NotificationBO(
            id: input.notificationDTO.id,
            title: input.notificationDTO.title,
            ownerUser: userMapper.map(UserDataMapper(userDTO: input.notificationOwnerUserDTO, authUserId: input.authUserId)),
            byUser: userMapper.map(UserDataMapper(userDTO: input.notificationUserDTO, authUserId: input.authUserId)),
            type: NotificationType(rawValue: input.notificationDTO.type),
            message: input.notificationDTO.message,
            timestamp: input.notificationDTO.timestamp,
            isRead: input.notificationDTO.isRead
        )
    }
}


struct NotificationDataMapper {
    var notificationDTO: NotificationDTO
    var notificationUserDTO: UserDTO
    var notificationOwnerUserDTO: UserDTO
    var authUserId: String
}
