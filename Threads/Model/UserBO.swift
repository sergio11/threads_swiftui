//
//  User.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import Foundation

struct UserBO: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var followers: Int = 0
    var following: Int = 0
}