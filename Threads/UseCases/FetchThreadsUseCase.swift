//
//  FetchThreadsUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum FetchThreadsError: Error {
    case fetchFailed
}

/// An entity responsible for fetching threads for the home screen.
struct FetchThreadsUseCase {
    let threadsRepository: ThreadsRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the fetch operation for threads to display on the home screen asynchronously.
    /// - Returns: A list of `ThreadBO` objects representing the threads for the home screen.
    /// - Throws: An error if the fetch operation fails.
    func execute() async throws -> [ThreadBO] {
        // Get the current user ID from the authentication repository.
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw FetchThreadsError.fetchFailed
        }
        do {
            // Fetch all threads from the threads repository.
            return try await threadsRepository.fetchThreads()
        } catch {
            throw FetchThreadsError.fetchFailed
        }
    }
}
