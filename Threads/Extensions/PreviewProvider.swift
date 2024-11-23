//
//  PreviewProvider.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
    
}


class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = UserBO(id: NSUUID().uuidString, fullname: "Sergio Sánchez", email: "dreamsoftware92@gmail.com", username: "ssanchez", isPrivateProfile: false, isFollowedByAuthUser: false)
    
    let thread = ThreadBO(threadId: "123456567", ownerUid: "123", caption: "This is a test thread", timestamp: Date(), likes: 0, user: UserBO(id: NSUUID().uuidString, fullname: "Sergio Sánchez", email: "dreamsoftware92@gmail.com", username: "ssanchez", isPrivateProfile: false, isFollowedByAuthUser: false))
    
    let notification = NotificationBO(
            id: "notif123",
            title: "New Follower",
            ownerUser: UserBO(id: NSUUID().uuidString, fullname: "Sergio Sánchez", email: "dreamsoftware92@gmail.com", username: "ssanchez", isPrivateProfile: false, isFollowedByAuthUser: false),
            byUser: UserBO(id: NSUUID().uuidString, fullname: "Sergio Sánchez", email: "dreamsoftware92@gmail.com", username: "ssanchez", isPrivateProfile: false, isFollowedByAuthUser: false),
            type: .follow,
            message: "Jane Smith started following you.",
            timestamp: Date(),
            isRead: false
        )
}
