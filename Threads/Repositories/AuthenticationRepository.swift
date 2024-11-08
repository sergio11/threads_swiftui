//
//  AuthenticationRepository.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Enum representing errors that can occur in the `AuthenticationRepository`.
enum AuthenticationRepositoryError: Error {
    /// Error indicating that sign-in failed.
    case signInFailed(message: String)
    /// Error indicating that verification failed.
    case verificationFailed
    /// Error indicating that sign-out failed.
    case signOutFailed
    /// Error indicating that fetching the current user ID failed.
    case currentUserFetchFailed
}

/// Protocol defining authentication operations.
protocol AuthenticationRepository {
    
    /// Signs in the user with the given email and password asynchronously.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including `signInFailed` if the sign-in fails.
    func signIn(email: String, password: String) async throws
    
    /// Signs out the current user asynchronously.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to sign-out failure.
    func signOut() async throws
    
    /// Fetches the current user ID asynchronously.
    /// - Returns: The current user ID as a string, or `nil` if no user is signed in.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to user ID fetching failure.
    func getCurrentUserId() async throws -> String?
}
