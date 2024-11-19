//
//  UpdateUserBO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 19/11/24.
//

import Foundation

struct UpdateUserBO: Codable {
    let userId: String
    let fullname: String
    let bio: String?
    let link: String?
    let selectedImage: Data?
    let isPrivateProfile: Bool
}
