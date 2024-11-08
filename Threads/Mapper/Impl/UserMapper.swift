//
//  UserMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

class UserMapper: Mapper {
    typealias Input = UserDTO
    typealias Output = UserBO
    
    func map(_ input: UserDTO) -> UserBO {
        return UserBO(
            id: input.userId,
            fullname: input.fullname,
            email: input.email,
            username: input.username,
            profileImageUrl: input.profileImageUrl,
            bio: input.bio,
            followers: input.followers.count,
            following: input.following.count
        )
    }
}
