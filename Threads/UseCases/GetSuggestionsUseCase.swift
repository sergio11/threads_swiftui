//
//  GetSuggestionsUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum GetSuggestionsError: Error {
    case fetchFailed
}

/// An entity responsible for fetching user suggestions.
struct GetSuggestionsUseCase {
    let userRepository: UserProfileRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the process of fetching user suggestions asynchronously.
        /// - Returns: An array of `User` objects representing the fetched user suggestions.
        /// - Throws: An error if the user suggestions fetching operation fails.
    func execute() async throws -> [UserBO] {
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw GetSuggestionsError.fetchFailed
        }
        do {
            return try await userRepository.getSuggestions(authUserId: userId)
        } catch {
            throw GetSuggestionsError.fetchFailed
        }
    }
}
