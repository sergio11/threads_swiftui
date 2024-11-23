//
//  ConnectionsViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import Foundation
import Combine
import Factory


class ConnectionsViewModel: BaseViewModel {
    
    @Injected(\.followUserUseCase) private var followUserUseCase: FollowUserUseCase
    @Injected(\.fetchUserConnectionsUseCase) private var fetchUserConnectionsUseCase: FetchUserConnectionsUseCase
    
    @Published var users: [UserBO] = []
    
    func fetchData(userId: String, connectionType: UserConnectionType) {
        executeAsyncTask {
            return try await self.fetchUserConnectionsUseCase.execute(params: FetchUserConnectionsParams(userId: userId, connectionType: connectionType))
        } completion: { [weak self] result in
            guard let self = self else { return }
            if case .success(let users) = result {
                self.onFetchUserConnectionsCompleted(users: users)
            }
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
    
    private func onFetchUserConnectionsCompleted(users: [UserBO]) {
        self.users = users
    }
    
    private func onFollowUserCompleted(userId: String) {
        // Find the index of the user to modify
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].isFollowedByAuthUser = !users[index].isFollowedByAuthUser
            // Reassign the array to trigger the UI update
            self.users = users
        }
    }
}
