//
//  ThreadDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Data Transfer Object for representing a thread.
internal struct ThreadDTO: Decodable {
    let threadId: String
    let ownerUid: String
    let caption: String
    let timestamp: Date
    let likedBy: [String]
    let likes: Int
}
