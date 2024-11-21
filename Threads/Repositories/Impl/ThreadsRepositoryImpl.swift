//
//  ThreadsRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Class responsible for managing thread-related operations.
///
/// `ThreadsRepositoryImpl` is an implementation of the `ThreadsRepository` protocol that handles all the
/// operations related to threads, such as uploading, fetching, liking, and fetching user-specific threads.
/// It interacts with the data sources for threads and user profiles and performs necessary mappings
/// to convert data transfer objects (DTOs) into business objects (BOs) that the application can use.
///
/// The class uses various mappers (`ThreadMapper`, `CreateThreadMapper`) and data sources (`ThreadsDataSource`,
/// `UserDataSource`) to interact with the data layer and convert raw data into business logic representations.
///
/// Example usage:
/// ```swift
/// let threadsRepo = ThreadsRepositoryImpl(
///     threadsDataSource: threadsDataSource,
///     threadMapper: threadMapper,
///     createThreadMapper: createThreadMapper,
///     userDataSource: userDataSource,
///     authenticationRepository: authenticationRepo
/// )
/// let threadBO = try await threadsRepo.uploadThread(data: createThreadBO)
/// let threads = try await threadsRepo.fetchThreads()
/// ```
internal class ThreadsRepositoryImpl: ThreadsRepository {
    
    private let threadsDataSource: ThreadsDataSource
    private let createThreadMapper: CreateThreadMapper
    private let threadMapper: ThreadMapper
    private let userDataSource: UserDataSource
    private let authenticationRepository: AuthenticationRepository
    
    /// Initializes an instance of `ThreadsRepositoryImpl`.
    ///
    /// - Parameters:
    ///   - threadsDataSource: The data source for thread-related operations, used to interact with raw thread data.
    ///   - threadMapper: The mapper used to map thread-related data objects from DTOs to BOs.
    ///   - createThreadMapper: The mapper used to map `CreateThreadBO` to the necessary DTO for thread creation.
    ///   - userDataSource: The data source for fetching user profile data.
    ///   - authenticationRepository: The repository used to manage user authentication and retrieve the current authenticated user's ID.
    init(
        threadsDataSource: ThreadsDataSource,
        threadMapper: ThreadMapper,
        createThreadMapper: CreateThreadMapper,
        userDataSource: UserDataSource,
        authenticationRepository: AuthenticationRepository
    ) {
        self.threadsDataSource = threadsDataSource
        self.threadMapper = threadMapper
        self.createThreadMapper = createThreadMapper
        self.userDataSource = userDataSource
        self.authenticationRepository = authenticationRepository
    }
    
    /// Uploads a new thread asynchronously.
    ///
    /// This method takes the details of a new thread, maps it to the necessary data transfer object (`CreateThreadDTO`),
    /// and uploads it to the data source. After uploading, it fetches the associated user data and maps the thread data to
    /// a business object (`ThreadBO`).
    ///
    /// - Parameter data: A `CreateThreadBO` object containing the details of the thread to be uploaded.
    /// - Returns: A `ThreadBO` object representing the uploaded thread, containing mapped thread details.
    /// - Throws: An error if the upload operation fails or the data conversion fails.
    func uploadThread(data: CreateThreadBO) async throws -> ThreadBO {
        do {
            // Map CreateThreadBO to CreateThreadDTO and upload
            let threadDTO = try await threadsDataSource.uploadThread(self.createThreadMapper.map(data))
            let userDTO = try await userDataSource.getUserById(userId: threadDTO.ownerUid)
            // Map the DTO to a business object (ThreadBO)
            return threadMapper.map(ThreadDataMapper(threadDTO: threadDTO, userDTO: userDTO, authUserId: threadDTO.ownerUid))
        } catch {
            // Handle and throw a custom error for upload failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.uploadFailed(message: "Failed to upload thread: \(error.localizedDescription)")
        }
    }
        
    /// Fetches all threads asynchronously.
    ///
    /// This method fetches all the threads from the data source, maps each thread from a data transfer object (`ThreadDTO`)
    /// to a business object (`ThreadBO`), and returns them as an array of `ThreadBO`.
    ///
    /// - Returns: An array of `ThreadBO` objects representing the fetched threads.
    /// - Throws: An error if the fetch operation fails, or if the thread mapping fails.
    func fetchThreads() async throws -> [ThreadBO] {
        do {
            // Fetch threads from the data source
            let threadsDTO = try await threadsDataSource.fetchThreads()
            return try await mapThreads(for: threadsDTO)
        } catch {
            // Handle and throw a custom error for fetch failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.fetchFailed(message: "Failed to fetch threads: \(error.localizedDescription)")
        }
    }
        
    /// Fetches threads created by a specific user asynchronously.
    ///
    /// This method fetches the threads created by a specific user, given the user's ID. It maps each thread's data
    /// from a DTO to a BO and returns them as an array of `ThreadBO`.
    ///
    /// - Parameter userId: The ID of the user whose threads to fetch.
    /// - Returns: An array of `ThreadBO` objects representing the user's threads.
    /// - Throws: An error if the fetch operation fails, or if the thread mapping fails.
    func fetchUserThreads(userId: String) async throws -> [ThreadBO] {
        do {
            // Fetch the user's threads from the data source
            let threadsDTO = try await threadsDataSource.fetchUserThreads(uid: userId)
            return try await mapThreads(for: threadsDTO)
        } catch {
            // Handle and throw a custom error for user threads fetch failure
            print(error.localizedDescription)
            throw ThreadsRepositoryError.userThreadsFetchFailed(message: "Failed to fetch user threads for userId \(userId): \(error.localizedDescription)")
        }
    }
    
    /// Likes or unlikes a thread by the specified user.
    ///
    /// This method allows a user to like or unlike a thread. It sends the like/unlike request to the data source
    /// and returns whether the operation was successful.
    ///
    /// - Parameter threadId: The ID of the thread to like or unlike.
    /// - Parameter userId: The ID of the user performing the like/unlike operation.
    /// - Returns: A boolean indicating whether the like/unlike operation succeeded.
    /// - Throws: An error if the like/unlike operation fails.
    func likeThread(threadId: String, userId: String) async throws -> Bool {
        do {
            // Perform the like/unlike operation and return its result
            let success = try await threadsDataSource.likeThread(threadId: threadId, userId: userId)
            return success
        } catch {
            // Catch any error from the data source and throw a custom error
            print("Error liking thread: \(error.localizedDescription)")
            throw ThreadsRepositoryError.likeOperationFailed(message: "Failed to like/unlike thread with ID \(threadId) for user \(userId): \(error.localizedDescription)")
        }
    }
    
    /// Maps an array of `ThreadDTO` objects to an array of `ThreadBO` objects.
    ///
    /// This method maps the raw data transfer objects (`ThreadDTO`) into business objects (`ThreadBO`). It uses a
    /// `userCache` to store user profiles and avoid repeated network requests for the same user, improving performance.
    ///
    /// - Parameter threadsDTO: An array of `ThreadDTO` objects representing the raw data for threads.
    /// - Returns: An array of `ThreadBO` objects, each representing a thread in the app's business logic.
    /// - Throws: An error if the mapping process fails or if user profiles cannot be fetched.
    private func mapThreads(for threadsDTO: [ThreadDTO]) async throws -> [ThreadBO] {
        guard let authUserId = try await self.authenticationRepository.getCurrentUserId() else {
            throw ThreadsRepositoryError.unknown(message: "Invalid auth user id")
        }
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
                let threadDataMapper = ThreadDataMapper(threadDTO: threadDTO, userDTO: userDTO, authUserId: authUserId)
                let threadBO = threadMapper.map(threadDataMapper)
                threadBOs.append(threadBO)
            }
        }
        return threadBOs
    }
}


