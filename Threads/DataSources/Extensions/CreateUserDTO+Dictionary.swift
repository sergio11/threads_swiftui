//
//  CreateUserDTO+Dictionary.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal extension CreateUserDTO {
    func asDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "username": username,
            "email": email,
            "fullname": fullname,
            "followers": [String](),
            "following": [String](),
            "isPrivateProfile": false
        ]
    }
}
