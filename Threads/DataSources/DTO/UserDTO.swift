//
//  UserDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal struct UserDTO: Decodable {
    var userId: String
    var email: String
    var fullname: String
    var username: String
    var bio: String?
    var profileImageUrl: String?
    var followers: [String]
    var following: [String]
}
