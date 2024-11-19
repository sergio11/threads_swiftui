//
//  UpdateUserUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Error types that may occur during the user update process.
enum UpdateUserError: Error {
    case updateFailed
}

/// Parameters required to update a user's profile.
struct UpdateUserParams {
    let fullname: String        // The full name of the user.
    let bio: String?            // The bio of the user (optional).
    let link: String?           // The user's link (optional).
    let selectedImage: Data?    // The image data for the user's profile picture (optional).
    let isPrivateProfile: Bool  // Whether the user's profile is private or not.
}

/// Use case for updating a user's profile information.
struct UpdateUserUseCase {
    let userRepository: UserProfileRepository  // Repository for user profile operations.
    let authRepository: AuthenticationRepository  // Repository for authentication-related operations.
    
    /// Executes the user update process.
    ///
    /// This method checks if the current user is authenticated, then updates their profile
    /// with the provided information.
    ///
    /// - Parameter params: The `UpdateUserParams` object containing the user's updated details.
    /// - Returns: The updated `UserBO` object representing the user's profile.
    /// - Throws: `UpdateUserError.updateFailed` if the user is not authenticated or the update fails.
    func execute(params: UpdateUserParams) async throws -> UserBO {
        // Retrieve the current authenticated user's ID.
        if let userId = try await authRepository.getCurrentUserId() {
            // Update the user's profile using the repository.
            return try await userRepository.updateUser(data: UpdateUserBO(
                userId: userId,
                fullname: params.fullname,
                bio: params.bio,
                link: params.link,
                selectedImage: params.selectedImage,
                isPrivateProfile: params.isPrivateProfile
            ))
        } else {
            // If no authenticated user is found, throw an error.
            throw UpdateUserError.updateFailed
        }
    }
}
