//
//  Thread.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//
import Foundation

struct ThreadBO: Identifiable, Codable {
    var id: String {
        return threadId
    }
    let threadId: String
    let ownerUid: String
    let caption: String
    let timestamp: Date
    var likes: Int
    let user: UserBO?
}
