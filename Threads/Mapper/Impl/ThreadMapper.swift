//
//  ThreadMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A class that implements the `Mapper` protocol to map a `ThreadDataMapper` to a `ThreadBO`.
/// It uses a `UserMapper` to map the `UserDTO` to a `UserBO`.
///
/// - The `ThreadMapper` class takes a `ThreadDataMapper` as input, which contains a `ThreadDTO` and a `UserDTO`.
/// - It returns a `ThreadBO` (Business Object) that is used in the app's domain layer.
/// - The `UserMapper` dependency is used to transform the `UserDTO` into a `UserBO`.
///
/// Example usage:
/// ```swift
/// let userMapper = UserMapper()
/// let threadMapper = ThreadMapper(userMapper: userMapper)
/// let threadDataMapper = ThreadDataMapper(threadDTO: someThreadDTO, userBO: someUserDTO)
/// let threadBO = threadMapper.map(threadDataMapper)
/// ```
class ThreadMapper: Mapper {
    /// Defines the input type as `ThreadDataMapper` and output type as `ThreadBO`.
    typealias Input = ThreadDataMapper
    typealias Output = ThreadBO
    
    // A userMapper instance responsible for mapping the `UserDTO` to `UserBO`.
    private let userMapper: UserMapper
    
    /// Initializes the `ThreadMapper` with a `UserMapper` dependency.
    ///
    /// - Parameter userMapper: An instance of `UserMapper` used to map `UserDTO` to `UserBO`.
    init(userMapper: UserMapper) {
        self.userMapper = userMapper
    }
    
    /// Maps a `ThreadDataMapper` to a `ThreadBO` object.
    ///
    /// This function converts the data transfer objects (`ThreadDTO` and `UserDTO`) into business objects (`ThreadBO` and `UserBO`).
    ///
    /// - Parameter data: A `ThreadDataMapper` object containing the `ThreadDTO` and `UserDTO`.
    /// - Returns: A `ThreadBO` object populated with the mapped data.
    func map(_ data: ThreadDataMapper) -> ThreadBO {
        return ThreadBO(
            threadId: data.threadDTO.threadId,
            ownerUid: data.threadDTO.ownerUid,
            caption: data.threadDTO.caption,
            timestamp: data.threadDTO.timestamp,
            likes: data.threadDTO.likes,
            user: userMapper.map(data.userDTO)
        )
    }
}

/// A struct that contains both the `ThreadDTO` and `UserDTO` data.
///
/// This struct is used as an intermediary data structure that holds the raw data (DTOs) needed to create a `ThreadBO`.
///
/// - `threadDTO`: Represents the data transfer object for the thread. It contains information about the thread itself, like ID, caption, timestamp, and likes.
/// - `userBO`: Represents the data transfer object for the user. It contains information about the user associated with the thread, like the username and profile details.
struct ThreadDataMapper {
    var threadDTO: ThreadDTO   // Represents the thread data transfer object
    var userDTO: UserDTO       // Represents the user data transfer object
}
