//
//  CreateThreadMapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

struct CreateThreadMapper {
    func map(_ data: CreateThreadBO) -> CreateThreadDTO {
        return CreateThreadDTO(
            threadId: data.threadId,
            ownerUid: data.ownerUid,
            caption: data.caption
        )
    }
}
