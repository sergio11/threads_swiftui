//
//  CreateThreadViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//

import Firebase

class CreateThreadViewModel: ObservableObject {
    
    @Published var caption = ""
    
    func uploadThread() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let thread = ThreadBO(threadId: "1234", ownerUid: uid, caption: caption, timestamp: Date(), likes: 0)
        try await ThreadService.uploadThread(thread)
    }
    
}
