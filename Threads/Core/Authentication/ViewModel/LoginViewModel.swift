//
//  LoginViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func signIn() async throws {
        try await AuthService.shared.login(
            withEmail: email,
            password: password
        )
    }
}
