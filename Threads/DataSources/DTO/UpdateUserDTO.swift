//
//  UpdateUserDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal struct UpdateUserDTO: Decodable {
    var userId: String
    var fullname: String
    var link: String?
    var isPrivateProfile: Bool
    var bio: String?
    var profileImageUrl: String?
}
