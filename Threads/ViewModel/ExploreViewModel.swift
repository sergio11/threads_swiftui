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
    
    @Injected(\.followUserUseCase) private var followUserUseCase: FollowUserUseCase
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
    
    func followUser(userId: String) {
        executeAsyncTask {
            return try await self.followUserUseCase.execute(params: FollowUserParams(userId: userId))
        } completion: { [weak self] result in
            guard let self = self else { return }
            if case .success(_) = result {
                self.onFollowUserCompleted(userId: userId)
            }
        }
    }
    
    private func onFollowUserCompleted(userId: String) {
        // Find the index of the user to modify
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].isFollowedByAuthUser = !users[index].isFollowedByAuthUser
            // Reassign the array to trigger the UI update
            self.users = users
        }
    }
    
    private func fetchSuggestions() {
        fetchUsers(using: self.getSuggestionsUseCase.execute)
    }

    private func searchUsers() {
        fetchUsers(using: { try await self.searchUsersUseCase.execute(params: SearchUsersParams(term: self.searchText)) })
    }
    
    private func fetchUsers(using fetchTask: @escaping () async throws -> [UserBO]) {
        executeAsyncTask({
            return try await fetchTask()
        }) { [weak self] (result: Result<[UserBO], Error>) in
            guard let self = self else { return }
            if case .success(let users) = result {
                self.onFetchDataCompleted(users: users)
            }
        }
    }
    
    private func onFetchDataCompleted(users: [UserBO]) {
        self.users = users
    }
}
