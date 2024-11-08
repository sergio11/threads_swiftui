//
//  FeedViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var threads = [ThreadBO]()
    
    init() {
        Task { try await fetchThreads() }
    }
    
    func fetchThreads() async throws {
        self.threads = try await ThreadService.fetchThreads()
        try await fetchUserDataForThreads()
    }
    
    private func fetchUserDataForThreads() async throws {
        for i in 0 ..< threads.count {
            let thread = threads[i]
            let ownerUid = thread.ownerUid
            let threadUser = try await UserService.fetchUser(withUid: ownerUid)
            threads[i].user = threadUser
        }
    }
}
