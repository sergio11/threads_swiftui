//
//  ThreadsRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Enum representing errors that can occur in the `ThreadsRepository`.
enum ThreadsRepositoryError: Error {
    case uploadFailed(message: String)
    case fetchFailed(message: String)
    case userThreadsFetchFailed(message: String)
    case unknown(message: String)
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
}
