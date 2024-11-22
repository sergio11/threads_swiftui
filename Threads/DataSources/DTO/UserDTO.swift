//
//  UserDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal struct UserDTO: Decodable, Hashable {
    var userId: String
    var email: String
    var fullname: String
    var username: String
    var bio: String?
    var link: String?
    var profileImageUrl: String?
    var followersCount: Int
    var followingCount: Int
    var followers: [String]
    var following: [String]
    var isPrivateProfile: Bool
}
