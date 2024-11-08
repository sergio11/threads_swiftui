//
//  ThreadsRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Class responsible for managing thread-related operations.
internal class ThreadsRepositoryImpl: ThreadsRepository {
    
    private let threadsDataSource: ThreadsDataSource
    private let createThreadMapper: CreateThreadMapper
    private let threadMapper: ThreadMapper
    
    /// Initializes an instance of `ThreadsRepositoryImpl`.
    /// - Parameters:
    ///   - threadsDataSource: The data source for thread-related operations.
    ///   - threadMapper: The mapper used to map thread-related data objects.
    ///   - createThreadMapper: The mapper used to map thread-related data objects.
    init(threadsDataSource: ThreadsDataSource, threadMapper: ThreadMapper, createThreadMapper: CreateThreadMapper) {
        self.threadsDataSource = threadsDataSource
        self.threadMapper = threadMapper
        self.createThreadMapper = createThreadMapper
    }
    
    /// Uploads a new thread asynchronously.
    /// - Parameter dto: The `CreateThreadBO` object containing the thread details.
    /// - Returns: A `ThreadBO` object representing the uploaded thread.
    /// - Throws: An error if the operation fails.
    func uploadThread(data: CreateThreadBO) async throws -> ThreadBO {
        do {
            // Map CreateThreadBO to CreateThreadDTO and upload
            let threadDTO = try await threadsDataSource.uploadThread(self.createThreadMapper.map(data))
            // Map the DTO to a business object (ThreadBO)
            return threadMapper.map(threadDTO)
        } catch {
            // Handle and throw a custom error for upload failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.uploadFailed(message: "Failed to upload thread: \(error.localizedDescription)")
        }
    }
        
    /// Fetches all threads asynchronously.
    /// - Returns: An array of `ThreadBO` objects representing the threads.
    /// - Throws: An error if the operation fails.
    func fetchThreads() async throws -> [ThreadBO] {
        do {
            // Fetch threads from the data source
            let threadsDTO = try await threadsDataSource.fetchThreads()
            // Map the DTOs to business objects (ThreadBOs)
            return threadsDTO.map { threadMapper.map($0) }
        } catch {
            // Handle and throw a custom error for fetch failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.fetchFailed(message: "Failed to fetch threads: \(error.localizedDescription)")
        }
    }
        
    /// Fetches threads created by a specific user asynchronously.
    /// - Parameter userId: The ID of the user whose threads to fetch.
    /// - Returns: An array of `ThreadBO` objects.
    /// - Throws: An error if the operation fails.
    func fetchUserThreads(userId: String) async throws -> [ThreadBO] {
        do {
            // Fetch the user's threads from the data source
            let threadsDTO = try await threadsDataSource.fetchUserThreads(uid: userId)
            // Map the DTOs to business objects (ThreadBOs)
            return threadsDTO.map { threadMapper.map($0) }
        } catch {
            // Handle and throw a custom error for user threads fetch failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.userThreadsFetchFailed(message: "Failed to fetch user threads for userId \(userId): \(error.localizedDescription)")
        }
    }
}
