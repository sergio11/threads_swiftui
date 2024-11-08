//
//  GetCurrentUserUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum GetCurrentUserError: Error {
    case userNotFound
}

/// An entity responsible for retrieving the current user's information.
struct GetCurrentUserUseCase {
    
    let authRepository: AuthenticationRepository
    let userRepository: UserProfileRepository
    
    /// Executes the process of retrieving the information of the current user asynchronously.
        /// - Returns: The information of the current user.
        /// - Throws: An error if the user information retrieval operation fails, including `userNotFound` if the current user is not found.
    func execute() async throws -> UserBO {
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw GetCurrentUserError.userNotFound
        }
        do {
            return try await userRepository.getUser(userId: userId)
        } catch {
            throw GetCurrentUserError.userNotFound
        }
    }
}
