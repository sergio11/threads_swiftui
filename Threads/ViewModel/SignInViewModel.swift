//
//  SignInViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import Foundation
import Factory
import Combine

@MainActor
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
            if case .success(_) = result {
                self.onSignInSuccess()
            }
        }
    }
    
    private func onSignInSuccess() {
        self.appEventBus.publish(event: .loggedIn)
    }
}
