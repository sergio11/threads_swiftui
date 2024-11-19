//
//  UserProfileRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// A repository for user profile-related operations.
protocol UserProfileRepository {
    
    /// Updates an existing user's profile with the provided details.
    ///
    /// - Parameter data: An `UpdateUserBO` object containing the updated user information.
    /// - Returns: The updated `UserBO` object representing the user.
    /// - Throws: Any error encountered during the profile update process.
    func updateUser(data: UpdateUserBO) async throws -> UserBO

       
    /// Creates a new user profile with the provided details.
    ///
    /// - Parameter data: A `CreateUserBO` object containing the new user's information.
    /// - Returns: The newly created `UserBO` object representing the user.
    /// - Throws: Any error encountered during the user creation process.
    func createUser(data: CreateUserBO) async throws -> UserBO

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
