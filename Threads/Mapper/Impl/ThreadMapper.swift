//
//  ThreadMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A simple mapper for converting `ThreadDTO` to `ThreadBO`.
struct ThreadMapper {
    func map(_ threadDTO: ThreadDTO) -> ThreadBO {
        return ThreadBO(
            threadId: threadDTO.threadId,
            ownerUid: threadDTO.ownerUid,
            caption: threadDTO.caption,
            timestamp: threadDTO.timestamp,
            likes: threadDTO.likes,
            user: nil
        )
    }
}
