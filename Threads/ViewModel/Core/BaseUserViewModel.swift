//
//  BaseUserViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import Foundation
import Factory

class BaseUserViewModel: BaseViewModel {
    
    @Injected(\.getCurrentUserUseCase) private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    @Published var authUserId: String = ""
    @Published var authUserFullName: String = ""
    @Published var authUserUsername: String = ""
    @Published var authUserProfileImageUrl: String = ""
    
    func loadCurrentUser() {
        executeAsyncTask {
            return try await self.getCurrentUserUseCase.execute()
        } completion: { [weak self] result in
            guard let self = self else { return }
            if case .success(let user) = result {
                self.onCurrentUserLoaded(user: user)
            }
        }
    }

    internal func onCurrentUserLoaded(user: UserBO) {
        self.authUserId = user.id
        self.authUserFullName = user.fullname
        self.authUserUsername = user.username
        self.authUserProfileImageUrl = user.profileImageUrl ?? ""
    }
}
