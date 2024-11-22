//
//  CreateThreadMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A mapper responsible for converting `CreateThreadBO` business objects into `CreateThreadDTO` data transfer objects.
struct CreateThreadMapper {
    
    /// Maps a `CreateThreadBO` object to a `CreateThreadDTO` object.
    ///
    /// - Parameter data: A `CreateThreadBO` instance containing the business logic representation of the thread.
    /// - Returns: A `CreateThreadDTO` instance containing the data transfer representation of the thread.
    func map(_ data: CreateThreadBO) -> CreateThreadDTO {
        return CreateThreadDTO(
            threadId: data.threadId,
            ownerUid: data.ownerUid,
            caption: data.caption
        )
    }
}
