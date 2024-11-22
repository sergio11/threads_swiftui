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
    
    @Injected(\.searchUsersUseCase) private var searchUsersUseCase: SearchUsersUseCase
    @Injected(\.getSuggestionsUseCase) private var getSuggestionsUseCase: GetSuggestionsUseCase
    
    @Published var searchText = "" {
        didSet {
            fetchData()
        }
    }
    @Published var users = [UserBO]()
    
    
    func fetchData() {
        if(!searchText.isEmpty) {
            searchUsers()
        } else {
            fetchSuggestions()
        }
    }
    
    func isUserFollowing(user: UserBO) -> Bool {
        return user.followers.contains(authUserId)
    }
    
    private func fetchSuggestions() {
        executeAsyncTask({
            return try await self.getSuggestionsUseCase.execute()
        }) { [weak self] (result: Result<[UserBO], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.onFetchDataCompleted(users: users)
            case .failure:
                self.onFetchDataFailed()
            }
        }
    }
    
    private func searchUsers() {
        executeAsyncTask({
            return try await self.searchUsersUseCase.execute(params: SearchUsersParams(term: self.searchText))
        }) { [weak self] (result: Result<[UserBO], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.onFetchDataCompleted(users: users)
            case .failure:
                self.onFetchDataFailed()
            }
        }
    }
    
    private func onFetchDataCompleted(users: [UserBO]) {
        self.isLoading = false
        self.users = users
    }

    private func onFetchDataFailed() {
        self.isLoading = false
    }
}
