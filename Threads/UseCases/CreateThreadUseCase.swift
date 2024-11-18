//
//  CreateThreadUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/11/24.
//

import Foundation

import Foundation

/// Enum representing errors that can occur during the creation of a thread.
enum CreateThreadError: Error {
    /// Error when the current user ID cannot be retrieved.
    case userNotAuthenticated
    /// Error when uploading the thread fails.
    case uploadFailed(message: String)
}

/// Parameters needed for creating a new thread.
struct CreateThreadParams {
    var caption: String
}

/// Use case responsible for creating a new thread.
struct CreateThreadUseCase {
    let authRepository: AuthenticationRepository
    let threadsRepository: ThreadsRepository

    /// Executes the creation of a new thread.
    /// - Parameter params: The parameters needed for creating the thread.
    /// - Returns: The created `ThreadBO` object.
    /// - Throws: `CreateThreadError` if any part of the process fails.
    func execute(params: CreateThreadParams) async throws -> ThreadBO {
        print("CreateThreadUseCase: Starting thread creation process with params: \(params)")

        // 1. Retrieve the current user's ID.
        guard let userId = try await authRepository.getCurrentUserId() else {
            print("CreateThreadUseCase: User is not authenticated.")
            throw CreateThreadError.userNotAuthenticated
        }
        print("CreateThreadUseCase: Retrieved user ID: \(userId)")

        // 2. Generate a unique thread ID using UUID.
        let threadId = UUID().uuidString
        print("CreateThreadUseCase: Generated thread ID: \(threadId)")

        // 3. Create the thread data object.
        let threadData = CreateThreadBO(threadId: threadId, ownerUid: userId, caption: params.caption)
        print("CreateThreadUseCase: Created thread data: \(threadData)")

        // 4. Upload the thread using the repository.
        do {
            print("CreateThreadUseCase: Uploading thread.")
            let threadCreated = try await threadsRepository.uploadThread(data: threadData)
            print("CreateThreadUseCase: Thread uploaded successfully.")
            return threadCreated
        } catch {
            let errorMessage = "Failed to upload thread: \(error.localizedDescription)"
            print("CreateThreadUseCase: \(errorMessage)")
            throw CreateThreadError.uploadFailed(message: errorMessage)
        }
    }
}
