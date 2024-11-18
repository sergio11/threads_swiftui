//
//  FirebaseAuthenticationDataSourceImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore

/// A data source responsible for handling authentication operations using Firestore.
internal class FirebaseAuthenticationDataSourceImpl: AuthenticationDataSource {
    
    
    /// Signs in using email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An `AuthenticationError` if sign-in fails.
    func signIn(email: String, password: String) async throws {
        do {
            // Attempt to sign in using Firebase's Auth API.
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                
            // Check if user information is available after sign-in.
            guard authResult.user.email != nil else {
                throw AuthenticationError.signInFailed(message: "User information is incomplete.")
            }
                
            print("Successfully signed in as: \(authResult.user.email ?? "Unknown email")")
        } catch {
            // Handle and rethrow the error with a custom message.
            print("Sign-in error: \(error.localizedDescription)")
            throw AuthenticationError.signInFailed(message: "Sign-in failed: \(error.localizedDescription)")
        }
    }
    
    /// Signs up a new user using email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The user ID (`uid`) of the newly created user.
    /// - Throws: An `AuthenticationError` if sign-up fails.
    func signUp(email: String, password: String) async throws -> String {
        do {
            // Attempt to create a user with email and password.
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            print("Successfully signed up user with ID: \(userId)")
            return userId
        } catch {
            // Handle and rethrow the error with a custom message.
            print("Sign-up error: \(error.localizedDescription)")
            throw AuthenticationError.signUpFailed(message: "Sign-up failed: \(error.localizedDescription)")
        }
    }
    
    /// Signs out the current user.
        /// - Throws: An `AuthenticationError` in case of failure, including `signOutFailed` if sign-out fails.
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            throw AuthenticationError.signOutFailed(message: "Sign-out failed: \(error.localizedDescription)")
        }
    }
        
    /// Retrieves the ID of the current user.
        /// - Returns: The user ID if the user is signed in, otherwise `nil`.
        /// - Throws: An `AuthenticationError` in case of failure.
    func getCurrentUserId() async throws -> String? {
        guard let userSession = Auth.auth().currentUser else {
            return nil
        }
        return userSession.uid
    }
}
