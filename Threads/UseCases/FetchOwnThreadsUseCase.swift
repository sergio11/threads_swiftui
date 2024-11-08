//
//  FetchOwnThreadsUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Enum representing errors that can occur when fetching threads for the authenticated user.
enum FetchOwnThreadsError: Error {
    case fetchFailed
}

/// An entity responsible for fetching threads owned by the current user.
struct FetchOwnThreadsUseCase {
    let threadsRepository: ThreadsRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the process of fetching threads owned by the current user asynchronously.
    /// - Returns: An array of `ThreadBO` objects representing the threads owned by the authenticated user.
    /// - Throws: An error if the thread fetching operation fails, including `fetchFailed` if the operation fails.
    func execute() async throws -> [ThreadBO] {
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw FetchOwnThreadsError.fetchFailed
        }
        do {
            // Fetch threads owned by the authenticated user from the repository.
            let ownThreads = try await threadsRepository.fetchUserThreads(userId: userId)
            return ownThreads
        } catch {
            throw FetchOwnThreadsError.fetchFailed
        }
    }
}
