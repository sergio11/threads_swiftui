//
//  UserContentListViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 6/8/24.
//

import Foundation

class UserContentListViewModel: ObservableObject {
    
    @Published var threads = [ThreadBO]()
    
    let user: UserBO
    
    init(user: UserBO) {
        self.user = user
        Task { try await fetchUserThreads() }
    }
    
    @MainActor
    func fetchUserThreads() async throws {
        var threads = try await ThreadService.fetchUserThreads(uid: user.id)
        for i in 0 ..< threads.count {
            threads[i].user = self.user
        }
        self.threads = threads
    }
    
}
