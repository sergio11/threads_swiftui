//
//  UserContentListViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 6/8/24.
//

import Foundation
import Factory
import Combine

class UserContentListViewModel: BaseViewModel {
    
    @Injected(\.fetchThreadsByUserUseCase) private var fetchThreadsByUserUseCase: FetchThreadsByUserUseCase
    
    @Published var threads = [ThreadBO]()
    @Published var selectedFilter: ProfileThreadFilter = .threads
    
    private var user: UserBO? = nil
    
    func loadUser(user: UserBO) {
        self.user = user
    }
    
    func fetchUserThreads() {
        print("fetchUserThreads")
        if let userId = user?.id {
            print("fetchUserThreads - userId: \(userId)")
            executeAsyncTask({
                return try await self.fetchThreadsByUserUseCase.execute(params: FetchThreadsByUserParams(userId: userId))
            }) { [weak self] (result: Result<[ThreadBO], Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let threads):
                    self.onFetchThreadsByUserCompleted(threads: threads)
                case .failure:
                    self.onFetchThreadsByUserFailed()
                }
            }
        }
    }
    
    private func onFetchThreadsByUserCompleted(threads: [ThreadBO]) {
        self.isLoading = false
        print("onFetchThreadsByUserCompleted - threads: \(threads.count)")
        self.threads = threads
    }
    
    private func onFetchThreadsByUserFailed() {
        self.isLoading = false
    }
}
