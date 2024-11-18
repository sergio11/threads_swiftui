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
    /// - Parameter message: A detailed message explaining why the sign-in failed.
    case signInFailed(message: String)
    
    /// Error indicating that the email verification process failed.
    case verificationFailed
    
    /// Error indicating that sign-out failed.
    /// This can happen if there is no authenticated user or if the sign-out process encounters an issue.
    case signOutFailed
    
    /// Error indicating that the user registration (sign-up) failed.
    /// - Parameter message: A detailed message explaining why the sign-up failed.
    case signUpFailed(message: String)
    
    /// Error indicating that fetching the current user ID failed.
    /// This can occur if there is no authenticated user or if the user session has expired.
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
    
    /// Registers a new user with the given email and password asynchronously.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The user ID (`uid`) of the newly created user.
    /// - Throws: An `AuthenticationRepositoryError` if the sign-up fails.
    func signUp(email: String, password: String) async throws -> String
    
    /// Signs out the current user asynchronously.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to sign-out failure.
    func signOut() async throws
    
    /// Fetches the current user ID asynchronously.
    /// - Returns: The current user ID as a string, or `nil` if no user is signed in.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to user ID fetching failure.
    func getCurrentUserId() async throws -> String?
}
