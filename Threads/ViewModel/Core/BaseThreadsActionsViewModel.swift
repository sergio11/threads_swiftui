//
//  BaseThreadsActionsViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 21/11/24.
//

import Foundation
import Factory
import Combine

class BaseThreadsActionsViewModel: BaseViewModel {
    
    @Injected(\.likeThreadUseCase) private var likeThreadUseCase: LikeThreadUseCase
    
    @Published var threads = [ThreadBO]()
    @Published var showShareSheet: Bool = false
    @Published var shareContent: String = ""
    
    func onShareTapped(thread: ThreadBO) {
        self.shareContent = "Check out this thread: \(thread.caption)"
        self.showShareSheet.toggle()
    }
    
    func likeThread(threadId: String) {
        executeAsyncTask({
            return try await self.likeThreadUseCase.execute(params: LikeThreadParams(threadId: threadId))
        }) { [weak self] (result: Result<Bool, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    self.onThreadLikeSuccessfully(threadId: threadId)
                } else {
                    self.onThreadLikeFailed()
                }
            case .failure:
                self.onThreadLikeFailed()
            }
        }
    }
    
    private func onThreadLikeSuccessfully(threadId: String) {
        self.isLoading = false
        // Find the index of the thread to modify
        if let index = threads.firstIndex(where: { $0.id == threadId }) {
            if threads[index].isLikedByAuthUser {
                threads[index].isLikedByAuthUser = false
                threads[index].likes -= 1
            } else {
                threads[index].isLikedByAuthUser = true
                threads[index].likes += 1
            }
            // Reassign the array to trigger the UI update
            self.threads = threads
        }
    }

    private func onThreadLikeFailed() {
        self.isLoading = false
    }
    
}
