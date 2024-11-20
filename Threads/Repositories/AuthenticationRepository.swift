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
    
    /// Error indicating that the email verification process failed.
    case verificationFailed
    
    /// Error indicating that sign-out failed.
    case signOutFailed
    
    /// Error indicating that the user registration (sign-up) failed.
    case signUpFailed(message: String)
    
    /// Error indicating that fetching the current user ID failed.
    case currentUserFetchFailed
    
    /// Error indicating that the password reset request failed.
    case passwordResetFailed(message: String)
}

/// Protocol defining authentication operations.
protocol AuthenticationRepository {
    
    /// Signs in the user with the given email and password asynchronously.
    func signIn(email: String, password: String) async throws
    
    /// Registers a new user with the given email and password asynchronously.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The user ID (`uid`) of the newly created user.
    /// - Throws: An `AuthenticationRepositoryError` if the sign-up fails.
    func signUp(email: String, password: String) async throws -> String
    
    /// Signs out the current user asynchronously.
    func signOut() async throws
    
    /// Fetches the current user ID asynchronously.
    /// - Returns: The current user ID as a string, or `nil` if no user is signed in.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure.
    func getCurrentUserId() async throws -> String?
    
    /// Sends a password reset email to the user's email address.
    /// - Parameter email: The user's email address to which the reset link will be sent.
    /// - Throws: An `AuthenticationRepositoryError` if the request fails.
    func forgotPassword(email: String) async throws
}
