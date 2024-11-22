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
/// The `ThreadMapper` class is responsible for converting the raw data transfer objects (DTOs) into
/// business objects (BOs) that are used in the application's domain layer.
///
/// - The `ThreadMapper` class takes a `ThreadDataMapper` as input, which contains a `ThreadDTO` and a `UserDTO`.
/// - It returns a `ThreadBO` (Business Object) that represents the thread in the application's domain layer.
/// - The `UserMapper` dependency is used to transform the `UserDTO` into a `UserBO`.
///
/// This class allows you to easily convert between data formats (DTOs) and the business objects used
/// in the app, making it easier to manage and manipulate thread-related data throughout the application.
///
/// Example usage:
/// ```swift
/// let userMapper = UserMapper()
/// let threadMapper = ThreadMapper(userMapper: userMapper)
/// let threadDataMapper = ThreadDataMapper(threadDTO: someThreadDTO, userDTO: someUserDTO, authUserId: someUserId)
/// let threadBO = threadMapper.map(threadDataMapper)
/// ```
///
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
    /// The `ThreadDTO` contains the thread's basic information such as its ID, caption, timestamp, and likes.
    /// The `UserDTO` contains information about the user who owns the thread, such as their username and profile image.
    /// The `ThreadMapper` maps these into a `ThreadBO`, which contains a `UserBO` and other business logic properties.
    ///
    /// - Parameter data: A `ThreadDataMapper` object containing the `ThreadDTO`, `UserDTO`, and the `authUserId`.
    /// - Returns: A `ThreadBO` object populated with the mapped data.
    ///
    /// - Note: This method also checks if the `authUserId` (the current authenticated user's ID) is present
    /// in the list of users who have liked the thread (`likedBy`), which is used to determine if the
    /// thread is liked by the authenticated user. This results in the `isLikedByAuthUser` flag in the `ThreadBO`.
    func map(_ data: ThreadDataMapper) -> ThreadBO {
        return ThreadBO(
            threadId: data.threadDTO.threadId,
            ownerUid: data.threadDTO.ownerUid,
            caption: data.threadDTO.caption,
            timestamp: data.threadDTO.timestamp,
            likes: data.threadDTO.likes,
            isLikedByAuthUser: data.threadDTO.likedBy.contains(data.authUserId),
            user: userMapper.map(UserDataMapper(userDTO: data.userDTO, authUserId: data.authUserId))
        )
    }
}

/// A struct that contains both the `ThreadDTO` and `UserDTO` data.
///
/// This struct is used as an intermediary data structure that holds the raw data (DTOs) needed to create a `ThreadBO`.
/// It allows the mapper to transform the `ThreadDTO` and `UserDTO` into a `ThreadBO`, a business object.
///
/// - `threadDTO`: Represents the data transfer object for the thread. It contains information about the thread itself,
///   such as the thread's unique ID (`threadId`), the owner ID (`ownerUid`), the thread's caption (`caption`),
///   the timestamp of creation (`timestamp`), the number of likes (`likes`), and the list of users who liked the thread (`likedBy`).
/// - `userDTO`: Represents the data transfer object for the user. It contains information about the user associated with the thread,
///   such as their username and profile image URL.
/// - `authUserId`: The ID of the currently authenticated user, used to determine if the current user has liked the thread.
struct ThreadDataMapper {
    var threadDTO: ThreadDTO   // Represents the thread data transfer object
    var userDTO: UserDTO       // Represents the user data transfer object
    var authUserId: String     // The ID of the authenticated user
}
