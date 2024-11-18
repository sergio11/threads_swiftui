//
//  AuthenticationRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

// Class responsible for authentication repository operations.
internal class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    private let authenticationDataSource: AuthenticationDataSource

    /// Initializes an instance of `AuthenticationRepositoryImpl`.
    /// - Parameter authenticationDataSource: The data source for authentication operations.
    init(authenticationDataSource: AuthenticationDataSource) {
        self.authenticationDataSource = authenticationDataSource
    }
    
    /// Signs in the user with the given email and password asynchronously.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including `signInFailed` if the sign-in fails.
    func signIn(email: String, password: String) async throws {
        do {
            try await authenticationDataSource.signIn(email: email, password: password)
        } catch {
            print("Sign-in failed: \(error.localizedDescription)")
            throw AuthenticationRepositoryError.signInFailed(message: "Sign-in failed: \(error.localizedDescription)")
        }
    }
    
    /// Registers a new user with the given email and password asynchronously.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The user ID (`uid`) of the newly created user.
    /// - Throws: An `AuthenticationRepositoryError` if the sign-up fails.
    func signUp(email: String, password: String) async throws -> String {
        do {
            // Delegate the sign-up operation to the data source.
            let userId = try await authenticationDataSource.signUp(email: email, password: password)
            print("Successfully signed up user with ID: \(userId)")
            return userId
        } catch {
            // Handle and rethrow the error with a custom message.
            print("Sign-up failed: \(error.localizedDescription)")
            throw AuthenticationRepositoryError.signUpFailed(message: "Sign-up failed: \(error.localizedDescription)")
        }
    }

    /// Signs out the current user asynchronously.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to sign-out failure.
    func signOut() async throws {
        do {
            try await authenticationDataSource.signOut()
        } catch {
            print(error.localizedDescription)
            throw AuthenticationRepositoryError.signOutFailed
        }
    }

    /// Fetches the current user ID asynchronously.
    /// - Returns: The current user ID as a string, or `nil` if no user is signed in.
    /// - Throws: An `AuthenticationRepositoryError` in case of failure, including specific errors related to user ID fetching failure.
    func getCurrentUserId() async throws -> String? {
        do {
            return try await authenticationDataSource.getCurrentUserId()
        } catch {
            print(error.localizedDescription)
            throw AuthenticationRepositoryError.currentUserFetchFailed
        }
    }
}
