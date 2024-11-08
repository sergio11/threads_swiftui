//
//  CreateThreadBO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

struct CreateThreadBO: Codable {
    let threadId: String
    let ownerUid: String
    let caption: String
}
