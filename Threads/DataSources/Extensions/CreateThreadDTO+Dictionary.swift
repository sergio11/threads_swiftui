//
//  CreateThreadDTO+Dictionary.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import Firebase

internal extension CreateThreadDTO {
    func asDictionary() -> [String: Any] {
        return [
            "threadId": threadId,
            "ownerUid": ownerUid,
            "caption": caption,
            "timestamp": Timestamp(date: Date()),
            "likes": 0
        ]
    }
}
