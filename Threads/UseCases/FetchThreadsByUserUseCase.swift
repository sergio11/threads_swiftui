//
//  FetchThreadsByUserUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/11/24.
//

import Foundation

/// Enum representing errors that can occur in the `FetchThreadsByUserUseCase`.
/// - `fetchFailed`: Indicates that fetching threads by user failed.
enum FetchThreadsByUserError: Error {
    case fetchFailed
}

/// Parameters required to fetch threads of a specific user.
/// - `userId`: The unique identifier of the user whose threads are to be fetched.
struct FetchThreadsByUserParams {
    var userId: String
}

/// Use case responsible for fetching threads by a specific user from the repository.
/// - It handles the business logic of fetching all threads created by a particular user.
struct FetchThreadsByUserUseCase {
    
    /// The repository used to fetch threads from the data source.
    let threadsRepository: ThreadsRepository
    
    /// Executes the process of fetching threads for a specific user.
    ///
    /// This method makes a call to the repository to fetch the threads for the user identified by `userId`.
    /// If the fetching process fails, it throws a `FetchThreadsByUserError.fetchFailed` error.
    ///
    /// - Parameter params: The parameters needed for fetching the threads. Specifically, `userId` is required.
    /// - Returns: A list of `ThreadBO` objects representing the threads created by the user.
    /// - Throws: `FetchThreadsByUserError.fetchFailed` if fetching the threads fails due to a data source error.
    func execute(params: FetchThreadsByUserParams) async throws -> [ThreadBO] {
        do {
            // Fetching threads from the repository
            return try await threadsRepository.fetchUserThreads(userId: params.userId)
        } catch {
            // If fetching fails, propagate the error
            throw FetchThreadsByUserError.fetchFailed
        }
    }
}


