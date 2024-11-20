//
//  ThreadsRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Enum representing errors that can occur in the `ThreadsRepository`.
enum ThreadsRepositoryError: Error {
    case uploadFailed(message: String)         // Error when uploading a thread fails
    case fetchFailed(message: String)          // Error when fetching threads fails
    case userThreadsFetchFailed(message: String) // Error when fetching a user's threads fails
    case unknown(message: String)              // Generic error for other unspecified failures
    case likeOperationFailed(message: String)  // New exception for like/unlike operation failures
}

/// Protocol defining operations for managing threads.
protocol ThreadsRepository {
    /// Uploads a new thread asynchronously.
    /// - Parameter data: The `CreateThreadBO` object containing the thread details.
    /// - Returns: A `ThreadBO` object representing the uploaded thread.
    /// - Throws: An error if the operation fails.
    func uploadThread(data: CreateThreadBO) async throws -> ThreadBO
    
    /// Fetches all threads asynchronously.
    /// - Returns: An array of `ThreadBO` objects representing the threads.
    /// - Throws: An error if the operation fails.
    func fetchThreads() async throws -> [ThreadBO]
    
    /// Fetches threads created by a specific user asynchronously.
    /// - Parameter userId: The ID of the user whose threads to fetch.
    /// - Returns: An array of `ThreadBO` objects.
    /// - Throws: An error if the operation fails.
    func fetchUserThreads(userId: String) async throws -> [ThreadBO]
    
    /// Likes or unlikes a thread by the specified user.
    /// - Parameter threadId: The ID of the thread to like or unlike.
    /// - Parameter userId: The ID of the user performing the like/unlike.
    /// - Returns: A boolean indicating if the operation succeeded.
    /// - Throws: An error if the like operation fails.
    func likeThread(threadId: String, userId: String) async throws -> Bool
}
