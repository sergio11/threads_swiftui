//
//  LikeThreadUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/11/24.
//

import Foundation

// Enum representing errors that can occur during the "like thread" process.
enum LikeThreadError: Error {
    /// Error when the user is not signed in or unable to retrieve user ID.
    case signInFailed
    /// Error when the like operation fails.
    case likeOperationFailed(message: String)
}

// Parameters for the like thread use case.
struct LikeThreadParams {
    var threadId: String
}

// The use case responsible for liking a thread by a user.
struct LikeThreadUseCase {
    let authRepository: AuthenticationRepository
    let threadRepository: ThreadsRepository
    
    /// Executes the like operation for a specific thread by the current user.
    /// - Parameter params: The parameters containing the thread ID to be liked.
    /// - Returns: A boolean indicating whether the like operation was successful.
    /// - Throws: An error if the user cannot be retrieved or the like operation fails.
    func execute(params: LikeThreadParams) async throws -> Bool {
        // 1. Retrieve the current user's ID after successful sign-in.
        guard let userId = try await authRepository.getCurrentUserId() else {
            print("LikeThreadUseCase: Failed to retrieve user ID.")
            throw LikeThreadError.signInFailed
        }
        print("LikeThreadUseCase: Successfully retrieved user ID: \(userId)")

        // 2. Perform the like or unlike operation for the thread.
        do {
            // Attempt to like/unlike the thread. The result is a boolean indicating success.
            let success = try await threadRepository.likeThread(threadId: params.threadId, userId: userId)
            print("LikeThreadUseCase: Successfully performed like/unlike operation.")
            return success
        } catch {
            print("LikeThreadUseCase: Failed to like/unlike thread with error: \(error.localizedDescription)")
            throw LikeThreadError.likeOperationFailed(message: "Failed to like/unlike thread with ID \(params.threadId) for user \(userId): \(error.localizedDescription)")
        }
    }
}
