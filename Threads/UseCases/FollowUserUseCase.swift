//
//  FollowUserUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 21/11/24.
//

import Foundation

/// Enum defining the possible errors that may occur during the follow user operation.
enum FollowUserError: Error {
    /// Error when retrieving the current authenticated user's ID fails.
    case signInFailed
    
    /// Error when the follow operation fails.
    case followOperationFailed(message: String)
}

/// Structure containing the parameters required to execute the follow user operation.
struct FollowUserParams {
    /// The ID of the user to be followed.
    var userId: String
}

/// Use case for following a user.
struct FollowUserUseCase {

    let authRepository: AuthenticationRepository
    let userProfileRepository: UserProfileRepository
    
    /// Executes the follow user use case.
    ///
    /// This method performs the following steps:
    /// 1. Retrieves the authenticated user's ID.
    /// 2. If successful, it calls the user profile repository to follow the target user.
    /// 3. If an error occurs during the follow operation, an error is thrown with a corresponding message.
    ///
    /// - Parameter params: The parameters required to execute the use case, including the user ID of the user to follow.
    /// - Returns: A boolean indicating whether the operation was successful or not.
    /// - Throws: `FollowUserError.signInFailed` if the authenticated user's ID cannot be retrieved, or `FollowUserError.followOperationFailed` if the follow operation fails.
    func execute(params: FollowUserParams) async throws -> Bool {
        // 1. Retrieve the authenticated user's ID.
        guard let authUserId = try await authRepository.getCurrentUserId() else {
            print("FollowUserUseCase: Failed to retrieve user ID.")
            throw FollowUserError.signInFailed
        }
        print("FollowUserUseCase: Successfully retrieved user ID: \(authUserId)")

        do {
            // 2. Attempt to follow the target user using the user profile repository.
            try await userProfileRepository.followUser(authUserId: authUserId, targetUserId: params.userId)
            return true
        } catch {
            // 3. If an error occurs during the follow operation, print and throw an error.
            print("FollowUserUseCase: Failed to follow user with error: \(error.localizedDescription)")
            throw FollowUserError.followOperationFailed(message: "Failed to follow user with ID \(params.userId): \(error.localizedDescription)")
        }
    }
}
