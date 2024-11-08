//
//  SignOutUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// An entity responsible for handling user sign-out operations.
struct SignOutUseCase {
    let repository: AuthenticationRepository
    
    /// Executes the sign-out operation asynchronously.
    /// - Throws: An error if the sign-out operation fails.
    func execute() async throws {
        try await repository.signOut()
    }
}
