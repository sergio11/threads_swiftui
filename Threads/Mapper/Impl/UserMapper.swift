//
//  UserMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A class responsible for mapping user data from the data source layer (`UserDataMapper`)
/// to the domain-specific business object (`UserBO`).
class UserMapper: Mapper {

    /// The input type for the mapper, defined as `UserDataMapper`.
    typealias Input = UserDataMapper

    /// The output type for the mapper, defined as `UserBO`.
    typealias Output = UserBO

    /// Maps a `UserDataMapper` instance to a `UserBO` instance.
    ///
    /// - Parameter input: An instance of `UserDataMapper` containing raw user data (`UserDTO`)
    ///   and the authenticated user's ID (`authUserId`).
    /// - Returns: A `UserBO` object with all relevant user information mapped from the data source.
    ///
    /// The mapping process includes:
    /// - Extracting user properties such as `id`, `fullname`, `email`, `username`, etc., from the `UserDTO`.
    /// - Determining whether the authenticated user follows the target user using the list of `followers`
    ///   from the `UserDTO` and comparing it to the provided `authUserId`.
    func map(_ input: UserDataMapper) -> UserBO {
        return UserBO(
            id: input.userDTO.userId,
            fullname: input.userDTO.fullname,
            email: input.userDTO.email,
            username: input.userDTO.username,
            profileImageUrl: input.userDTO.profileImageUrl,
            bio: input.userDTO.bio,
            link: input.userDTO.link,
            followers: input.userDTO.followers,
            following: input.userDTO.following,
            isPrivateProfile: input.userDTO.isPrivateProfile,
            isFollowedByAuthUser: input.userDTO.followers.contains(input.authUserId)
        )
    }
}

/// A struct that acts as a data wrapper for the mapping process from the data source to the domain layer.
struct UserDataMapper {

    /// The raw user data retrieved from a data source, encapsulated in a `UserDTO`.
    var userDTO: UserDTO

    /// The ID of the authenticated user. This is used to compute derived properties such as
    /// whether the authenticated user follows the target user.
    var authUserId: String
}
