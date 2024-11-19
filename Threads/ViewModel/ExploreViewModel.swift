//
//  ExploreViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import Foundation
import Factory
import Combine

@MainActor
class ExploreViewModel: BaseViewModel {
    
    @Injected(\.getSuggestionsUseCase) private var getSuggestionsUseCase: GetSuggestionsUseCase
    
    @Published var searchText = ""
    @Published var users = [UserBO]()
    
    func signIn() {
        executeAsyncTask({
            return try await self.getSuggestionsUseCase.execute()
        }) { [weak self] (result: Result<[UserBO], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.onGetSuggestionsCompleted(users: users)
            case .failure:
                self.onGetSuggestionsFailed()
            }
        }
    }
    
    private func onGetSuggestionsCompleted(users: [UserBO]) {
        self.isLoading = false
        self.users = users
    }

    private func onGetSuggestionsFailed() {
        self.isLoading = false
    }
}
