//
//  CreateUserDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal struct CreateUserDTO: Decodable {
    var userId: String
    var email: String
    var fullname: String
    var username: String
}
