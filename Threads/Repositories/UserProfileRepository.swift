//
//  UserProfileRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A repository for user profile-related operations.
protocol UserProfileRepository {
    /// Updates the user's profile information asynchronously.
    /// - Parameters:
    ///   - userId: The ID of the user whose profile is being updated.
    ///   - fullname: The full name of the user.
    ///   - username: The username of the user.
    ///   - bio: The bio of the user, if provided.
    ///   - selectedImage: The selected profile image data, if provided.
    /// - Returns: A `User` object representing the updated user profile.
    /// - Throws: An error if the profile update fails.
    func updateUser(userId: String, fullname: String, username: String, bio: String?, selectedImage: Data?) async throws -> UserBO

    /// Creates a new user asynchronously.
    /// - Parameters:
    ///   - userId: The ID of the new user.
    ///   - fullname: The full name of the user.
    ///   - username: The username of the new user.
    ///   - email: The email address of the new user.
    /// - Returns: A `User` object representing the newly created user.
    /// - Throws: An error if user creation fails.
    func createUser(userId: String, fullname: String, username: String, email: String) async throws -> UserBO

    /// Retrieves user information asynchronously.
    /// - Parameter userId: The ID of the user to retrieve.
    /// - Returns: A `User` object representing the retrieved user.
    /// - Throws: An error if user retrieval fails.
    func getUser(userId: String) async throws -> UserBO

    /// Checks the availability of a username asynchronously.
    /// - Parameter username: The username to check for availability.
    /// - Returns: A boolean value indicating whether the username is available or not.
    /// - Throws: An error if the availability check fails.
    func checkUsernameAvailability(username: String) async throws -> Bool

    /// Fetches user suggestions for the specified authenticated user asynchronously.
    /// - Parameter authUserId: The ID of the authenticated user for whom to fetch suggestions.
    /// - Returns: An array of `User` objects representing user suggestions.
    /// - Throws: An error if suggestion retrieval fails.
    func getSuggestions(authUserId: String) async throws -> [UserBO]
}
