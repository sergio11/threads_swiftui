//
//  ForgotPasswordViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/11/24.
//

import Foundation
import Factory
import Combine

@MainActor
class ForgotPasswordViewModel: BaseViewModel {
    
    @Injected(\.forgotPasswordUseCase) private var forgotPasswordUseCase: ForgotPasswordUseCase
    
    @Published var resetLinkSent: Bool = false
    @Published var email = ""
    
    func sendResetLink() {
        executeAsyncTask({
            return try await self.forgotPasswordUseCase.execute(params: ForgotPasswordParams(email: self.email))
        }) { [weak self] (result: Result<Bool, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.onSendResetLinkCompleted()
            case .failure:
                self.onSendResetLinkFailed()
            }
        }
    }
    
    private func onSendResetLinkCompleted() {
        self.isLoading = false
        self.resetLinkSent = true
    }
    
    private func onSendResetLinkFailed() {
        self.isLoading = false
    }
}
