//
//  CreateThreadDTO.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Data Transfer Object for creating a new thread.
internal struct CreateThreadDTO: Decodable {
    var threadId: String
    var ownerUid: String
    var caption: String
}
