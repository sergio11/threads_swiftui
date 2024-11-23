//
//  FeedViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//

import Foundation
import Combine
import Factory

@MainActor
class FeedViewModel: BaseThreadsActionsViewModel {
    
    @Injected(\.fetchThreadsUseCase) private var fetchThreadsUseCase: FetchThreadsUseCase
    
    func fetchThreads() {
        executeAsyncTask({
            return try await self.fetchThreadsUseCase.execute()
        }) { [weak self] (result: Result<[ThreadBO], Error>) in
            guard let self = self else { return }
            if case .success(let threads) = result {
                self.onFetchThreadsCompleted(threads: threads)
            }
        }
    }
    
    private func onFetchThreadsCompleted(threads: [ThreadBO]) {
        self.threads = threads
    }
}
