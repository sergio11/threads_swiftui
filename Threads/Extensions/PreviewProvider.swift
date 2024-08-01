//
//  PreviewProvider.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
    
}


class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = User(id: NSUUID().uuidString, fullname: "Sergio Sánchez", email: "dreamsoftware92@gmail.com", username: "ssanchez")
    
    let thread = Thread(ownerUid: "123", caption: "This is a test thread", timestamp: Timestamp(), likes: 0)
}
