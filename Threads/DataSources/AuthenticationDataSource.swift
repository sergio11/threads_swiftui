//
//  AuthenticationDataSource.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// An enumeration representing possible authentication errors.
enum AuthenticationError: Error {
    /// Error indicating failure in signing in.
    case signInFailed(message: String)
    /// Error indicating failure in signing out.
    case signOutFailed(message: String)
    /// Error indicating failure in signing up.
    case signUpFailed(message: String)
    /// Error indicating failure in sending the password reset email.
    case passwordResetFailed(message: String)
}

/// A protocol defining authentication operations.
protocol AuthenticationDataSource {
    
    /// Signs in using email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An `AuthenticationError` if sign-in fails.
    func signIn(email: String, password: String) async throws
    
    /// Signs up a new user using email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The user ID (`uid`) of the newly created user.
    /// - Throws: An `AuthenticationError` if sign-up fails.
    func signUp(email: String, password: String) async throws -> String
    
    /// Signs out the current user.
    /// - Throws: An `AuthenticationError` in case of failure, including `signOutFailed` if sign-out fails.
    func signOut() async throws
    
    /// Retrieves the current user's ID.
    /// - Returns: The user ID if the user is logged in, otherwise `nil`.
    /// - Throws: An `AuthenticationError` in case of failure.
    func getCurrentUserId() async throws -> String?
    
    /// Sends a password reset email to the user's email address.
    /// - Parameter email: The user's email address to which the reset link will be sent.
    /// - Throws: An `AuthenticationError` if the request fails.
    func forgotPassword(email: String) async throws
}
