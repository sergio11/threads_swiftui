//
//  UpdateUserDTO+Dictionary.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

internal extension UpdateUserDTO {
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "userId": userId,
            "fullname": fullname,
            "isPrivateProfile": isPrivateProfile
        ]
        if let bio = bio {
            dictionary["bio"] = bio
        }
        if let link = link {
            dictionary["link"] = link
        }
        if let profileImageUrl = profileImageUrl {
            dictionary["profileImageUrl"] = profileImageUrl
        }
        return dictionary
    }
}
