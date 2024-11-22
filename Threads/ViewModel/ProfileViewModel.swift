//
//  ProfileViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/11/24.
//

import Foundation
import Factory
import Combine

class ProfileViewModel: BaseUserViewModel {
    
    @Injected(\.followUserUseCase) private var followUserUseCase: FollowUserUseCase
    @Injected(\.signOutUseCase) private var signOutUseCase: SignOutUseCase
    @Injected(\.eventBus) private var appEventBus: EventBus<AppEvent>
    
    @Published var showEditProfile = false
    @Published var isAuthUser = false
    @Published var user: UserBO? = nil
    @Published var showSignOutAlert = false
    
    func loadUser(user: UserBO) {
        self.user = user
    }

    func signOut() {
        executeAsyncTask({
            return try await self.signOutUseCase.execute()
        }) { [weak self] (result: Result<Void, Error>) in
            guard let self = self else { return }
            self.onSignOutCompleted()
        }
    }
    
    func followUser() {
        if let userId = user?.id {
            executeAsyncTask {
                return try await self.followUserUseCase.execute(params: FollowUserParams(userId: userId))
            } completion: { [weak self] result in
                guard let self = self else { return }
                if case .success(_) = result {
                    self.onFollowUserCompleted()
                }
            }
        }
    }
    
    override func onCurrentUserLoaded(user: UserBO) {
        super.onCurrentUserLoaded(user: user)
        self.user = user
        self.isAuthUser = true
    }
    
    private func onSignOutCompleted() {
        self.isLoading = false
        self.appEventBus.publish(event: .loggedOut)
    }
    
    private func onFollowUserCompleted() {
        if var user = user {
            if user.isFollowedByAuthUser {
                user.isFollowedByAuthUser = false
                user.followers.removeAll(where: { $0 == authUserId })
            } else {
                user.isFollowedByAuthUser = true
                user.followers.append(authUserId)
            }
            self.user = user
        }
    }
}

