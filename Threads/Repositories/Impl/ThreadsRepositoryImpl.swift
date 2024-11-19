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
    private let userDataSource: UserDataSource
    
    /// Initializes an instance of `ThreadsRepositoryImpl`.
    /// - Parameters:
    ///   - threadsDataSource: The data source for thread-related operations.
    ///   - threadMapper: The mapper used to map thread-related data objects.
    ///   - createThreadMapper: The mapper used to map thread-related data objects.
    ///   - userDataSource: The data source for fetching user profiles.
    init(
        threadsDataSource: ThreadsDataSource,
        threadMapper: ThreadMapper,
        createThreadMapper: CreateThreadMapper,
        userDataSource: UserDataSource
    ) {
        self.threadsDataSource = threadsDataSource
        self.threadMapper = threadMapper
        self.createThreadMapper = createThreadMapper
        self.userDataSource = userDataSource
    }
    
    /// Uploads a new thread asynchronously.
    /// - Parameter data: The `CreateThreadBO` object containing the thread details.
    /// - Returns: A `ThreadBO` object representing the uploaded thread.
    /// - Throws: An error if the operation fails.
    func uploadThread(data: CreateThreadBO) async throws -> ThreadBO {
        do {
            // Map CreateThreadBO to CreateThreadDTO and upload
            let threadDTO = try await threadsDataSource.uploadThread(self.createThreadMapper.map(data))
            let userDTO = try await userDataSource.getUserById(userId: threadDTO.ownerUid)
            // Map the DTO to a business object (ThreadBO)
            return threadMapper.map(ThreadDataMapper(threadDTO: threadDTO, userDTO: userDTO))
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
            return try await loadUserProfiles(for: threadsDTO)
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
            return try await loadUserProfiles(for: threadsDTO)
        } catch {
            // Handle and throw a custom error for user threads fetch failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.userThreadsFetchFailed(message: "Failed to fetch user threads for userId \(userId): \(error.localizedDescription)")
        }
    }
    
    /// Loads the user profiles for a list of threads, ensuring each user profile is fetched only once within this operation.
    /// - Parameter threadsDTO: An array of `ThreadDTO` objects.
    /// - Parameter cache: A reference to a dictionary that will store user profiles during the operation.
    /// - Returns: An array of `ThreadBO` objects with fully mapped user profiles.
    private func loadUserProfiles(for threadsDTO: [ThreadDTO]) async throws -> [ThreadBO] {
        // Use a local cache to track user profiles during this operation
        var userCache: [String: UserDTO] = [:]
        // Map the threadDTOs to threadBOs, using the cached user profiles
        var threadBOs = [ThreadBO]()
        for threadDTO in threadsDTO {
            let userId = threadDTO.ownerUid
            // If user profile is not cached, fetch it and store in cache
            if userCache[userId] == nil {
                do {
                    let userDTO = try await userDataSource.getUserById(userId: userId)
                    userCache[userId] = userDTO
                } catch {
                    print("Failed to fetch user profile for userId: \(userId), error: \(error.localizedDescription)")
                }
            }
            // After ensuring user profile is cached, map the threadDTO to threadBO
            if let userDTO = userCache[userId] {
                let threadDataMapper = ThreadDataMapper(threadDTO: threadDTO, userDTO: userDTO)
                let threadBO = threadMapper.map(threadDataMapper)
                threadBOs.append(threadBO)
            }
        }
        return threadBOs
    }
}

