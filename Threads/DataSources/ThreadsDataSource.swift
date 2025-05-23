//
//  ThreadsDataSource.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

// Enum representing errors that can occur in the `ThreadsDataSource`.
enum ThreadsDataSourceError: Error {
    /// Error indicating that uploading a thread failed.
    case uploadFailed
    /// Error indicating that the thread was not found.
    case threadNotFound
    /// Error indicating that the provided thread ID is invalid.
    case invalidThreadId(message: String)
    /// Error indicating that fetching threads failed.
    case fetchThreadsFailed
    /// Error indicating that fetching user threads failed.
    case fetchUserThreadsFailed
    /// Error indicating that the like operation failed (e.g., user already liked the thread).
    case likeFailed
}

/// Protocol defining data source operations for threads.
protocol ThreadsDataSource {
    
    /// Uploads a new thread using the given DTO.
    /// - Parameter dto: The `CreateThreadDTO` object containing thread details.
    /// - Throws: An error if the upload fails.
    /// - Returns: A `ThreadDTO` representing the uploaded thread.
    func uploadThread(_ dto: CreateThreadDTO) async throws -> ThreadDTO
    
    /// Fetches all threads from Firestore.
    /// - Returns: An array of `ThreadDTO` objects.
    /// - Throws: An error if fetching fails.
    func fetchThreads() async throws -> [ThreadDTO]
    
    /// Fetches threads created by a specific user.
    /// - Parameter uid: The user ID whose threads are to be fetched.
    /// - Returns: An array of `ThreadDTO` objects.
    /// - Throws: An error if fetching fails.
    func fetchUserThreads(uid: String) async throws -> [ThreadDTO]
    
    /// Likes or dislikes a thread by the user.
    /// - Parameters:
    ///   - threadId: The ID of the thread to like/dislike.
    ///   - userId: The ID of the user performing the action.
    /// - Throws: An error if the operation fails.
    /// - Returns: A boolean indicating if the operation was successful.
    func likeThread(threadId: String, userId: String) async throws -> Bool
}
