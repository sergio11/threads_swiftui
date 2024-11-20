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
class ExploreViewModel: BaseUserViewModel {
    
    @Injected(\.getSuggestionsUseCase) private var getSuggestionsUseCase: GetSuggestionsUseCase
    
    @Published var searchText = "" {
        didSet {
            if(!searchText.isEmpty) {
                search()
            }
        }
    }
    @Published var users = [UserBO]()
    
    func search() {
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
    
    func isUserFollowing(user: UserBO) -> Bool {
        return user.followers.contains(authUserId)
    }
    
    private func onGetSuggestionsCompleted(users: [UserBO]) {
        self.isLoading = false
        self.users = users
    }

    private func onGetSuggestionsFailed() {
        self.isLoading = false
    }
}
