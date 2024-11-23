//
//  UserContentListViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 6/8/24.
//

import Foundation
import Factory
import Combine

@MainActor
class UserContentListViewModel: BaseThreadsActionsViewModel {
    
    @Injected(\.fetchThreadsByUserUseCase) private var fetchThreadsByUserUseCase: FetchThreadsByUserUseCase
    
    @Published var selectedFilter: ProfileThreadFilter = .threads
    
    private var user: UserBO? = nil
    
    func loadUser(user: UserBO) {
        self.user = user
    }
    
    func fetchUserThreads() {
        if let userId = user?.id {
            executeAsyncTask({
                return try await self.fetchThreadsByUserUseCase.execute(params: FetchThreadsByUserParams(userId: userId))
            }) { [weak self] (result: Result<[ThreadBO], Error>) in
                guard let self = self else { return }
                if case .success(let threads) = result {
                    self.onFetchThreadsByUserCompleted(threads: threads)
                }
            }
        }
    }
    
    private func onFetchThreadsByUserCompleted(threads: [ThreadBO]) {
        self.threads = threads
    }
}
