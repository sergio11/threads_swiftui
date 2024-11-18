//
//  SignInViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import Foundation
import Factory
import Combine

class SignInViewModel: BaseViewModel {
    
    @Injected(\.signInUseCase) private var signInUseCase: SignInUseCase
    @Injected(\.eventBus) internal var appEventBus: EventBus<AppEvent>
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        executeAsyncTask({
            return try await self.signInUseCase.execute(params: SignInParams(email: self.email, password: self.password))
        }) { [weak self] (result: Result<UserBO, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.onSignInSuccess()
            case .failure:
                self.onSignInFailed()
            }
        }
    }
    
    private func onSignInSuccess() {
        self.isLoading = false
        self.appEventBus.publish(event: .loggedIn)
    }

    private func onSignInFailed() {
        self.isLoading = false
    }
}
