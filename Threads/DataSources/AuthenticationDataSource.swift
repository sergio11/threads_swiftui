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
}

/// A protocol defining authentication operations.
protocol AuthenticationDataSource {
    
    /// Signs in using email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An `AuthenticationError` if sign-in fails.
    func signIn(email: String, password: String) async throws
    
    /// Signs out the current user.
    /// - Throws: An `AuthenticationError` in case of failure, including `signOutFailed` if sign-out fails.
    func signOut() async throws
    
    /// Retrieves the current user's ID.
    /// - Returns: The user ID if the user is logged in, otherwise `nil`.
    /// - Throws: An `AuthenticationError` in case of failure.
    func getCurrentUserId() async throws -> String?
}