//
//  CreateUserBO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 19/11/24.
//

import Foundation

struct CreateUserBO: Codable {
    let userId: String
    let fullname: String
    let username: String
    let email: String
}
