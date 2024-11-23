//
//  SignUpViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import Foundation
import Factory
import Combine

@MainActor
class SignUpViewModel: BaseViewModel {
    
    @Injected(\.signUpUseCase) private var signUpUseCase: SignUpUseCase
    @Injected(\.eventBus) internal var appEventBus: EventBus<AppEvent>
    
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var fullname = ""
    @Published var username = ""
    
    func signUp() {
        executeAsyncTask({
            return try await self.signUpUseCase.execute(params: SignUpParams(
                username: self.username,
                email: self.email,
                password: self.password,
                repeatPassword: self.repeatPassword,
                fullname: self.fullname
            ))
        }) { [weak self] (result: Result<UserBO, Error>) in
            guard let self = self else { return }
            if case .success(_) = result {
                self.onSignUpSuccess()
            }
        }
    }
    
    private func onSignUpSuccess() {
        self.appEventBus.publish(event: .loggedIn)
    }
}
