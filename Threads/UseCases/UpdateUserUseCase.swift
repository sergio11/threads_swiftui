//
//  UpdateUserUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum UpdateUserError: Error {
    case updateFailed
}

struct UpdateUserParams {
    var fullname: String
    var username: String
    var bio: String?
    let selectedImage: Data?
}

/// An entity responsible for updating user information.
struct UpdateUserUseCase {
    let userRepository: UserProfileRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the user information update asynchronously.
        /// - Parameters:
        ///   - params: Parameters containing the updated user information.
        /// - Returns: The updated user object.
        /// - Throws: An error if the update fails or if the current user session is invalid.
    func execute(params: UpdateUserParams) async throws -> UserBO {
        if let userId = try await authRepository.getCurrentUserId() {
            return try await userRepository.updateUser(userId: userId, fullname: params.fullname, username: params.username, bio: params.bio, selectedImage: params.selectedImage)
        } else {
            throw UpdateUserError.updateFailed
        }
    }
}
