//
//  SignUpUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum SignUpError: Error {
    /// Error when the username is not available.
    case usernameNotAvailable
    /// Error when the passwords do not match.
    case passwordsDoNotMatch
    /// Error when sign-in fails during the sign-up process.
    case signInFailed
    /// Error when creating the user profile fails.
    case createUserFailed(message: String)
}

/// Parameters needed for signing up a new user.
struct SignUpParams {
    var username: String
    var email: String
    var password: String
    var repeatPassword: String
    var fullname: String
}

/// An entity responsible for signing up a new user.
struct SignUpUseCase {
    let authRepository: AuthenticationRepository
    let userRepository: UserProfileRepository
    
    /// Executes the sign-up process.
    /// - Parameter params: The parameters needed for signing up a user.
    /// - Returns: The created `UserBO` object.
    /// - Throws: `SignUpError` if any part of the process fails.
    func execute(params: SignUpParams) async throws -> UserBO {
        // 1. Check if the passwords match.
        guard params.password == params.repeatPassword else {
            throw SignUpError.passwordsDoNotMatch
        }

        // 2. Check if the username is available.
        let isUsernameAvailable = try await userRepository.checkUsernameAvailability(username: params.username)
        guard isUsernameAvailable else {
            throw SignUpError.usernameNotAvailable
        }

        // 3. Sign in with the provided email and password.
        do {
            try await authRepository.signIn(email: params.email, password: params.password)
        } catch {
            throw SignUpError.signInFailed
        }

        // 4. Retrieve the current user's ID after sign-in.
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw SignUpError.signInFailed
        }

        // 5. Create the user profile in the UserProfileRepository.
        do {
            let userBO = try await userRepository.createUser(
                userId: userId,
                fullname: params.fullname,
                username: params.username,
                email: params.email
            )
            return userBO
        } catch {
            throw SignUpError.createUserFailed(message: "Failed to create user profile: \(error.localizedDescription)")
        }
    }
}

