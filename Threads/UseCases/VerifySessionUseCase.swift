//
//  VerifySessionUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum VerifySessionError: Error {
    case invalidSession
}

/// An entity responsible for verifying the current user session.
struct VerifySessionUseCase {
    let authRepository: AuthenticationRepository
    let userProfileRepository: UserProfileRepository
    
    /// Executes the session verification asynchronously.
        /// - Returns: A boolean indicating whether the session is valid.
        /// - Throws: An error if the session is invalid or if an error occurs during the verification process.
    func execute() async throws -> Bool {
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw VerifySessionError.invalidSession
        }
        var userData: UserBO? = nil
        do {
            userData = try await userProfileRepository.getUser(userId: userId)
        } catch {
            try await authRepository.signOut()
            throw VerifySessionError.invalidSession
        }
        return userData != nil
    }
}
