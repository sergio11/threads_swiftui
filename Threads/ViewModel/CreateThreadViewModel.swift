//
//  CreateThreadViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//

import Factory
import Foundation
import Combine

@MainActor
class CreateThreadViewModel: BaseUserViewModel {
    
    @Injected(\.createThreadUseCase) private var createThreadUseCase: CreateThreadUseCase
    
    @Published var caption = ""
    @Published var threadUploaded = false
    
    func uploadThread() {
        executeAsyncTask({
            return try await self.createThreadUseCase.execute(params: CreateThreadParams(caption: self.caption))
        }) { [weak self] (result: Result<ThreadBO, Error>) in
            guard let self = self else { return }
            if case .success(_) = result {
                self.onCreateThreadCompleted()
            }
        }
    }
    
    private func onCreateThreadCompleted() {
        self.threadUploaded = true
    }
}
