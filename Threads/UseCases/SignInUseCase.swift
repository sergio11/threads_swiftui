//
//  SignInUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

enum SignInError: Error {
    /// Error when the email or password is incorrect.
    case invalidCredentials
    /// Error when sign-in fails during the authentication process.
    case signInFailed
}

/// Parameters needed for signing in an existing user.
struct SignInParams {
    var email: String
    var password: String
}

/// An entity responsible for signing in a user with email and password.
struct SignInUseCase {
    let authRepository: AuthenticationRepository
    let userProfileRepository: UserProfileRepository
    
    /// Executes the sign-in process.
    /// - Parameter params: The parameters needed for signing in a user.
    /// - Returns: A `UserBO` object representing the authenticated user.
    /// - Throws: `SignInError` if any part of the process fails.
    func execute(params: SignInParams) async throws -> UserBO {
        // 1. Attempt to sign in with the provided email and password.
        do {
            try await authRepository.signIn(email: params.email, password: params.password)
        } catch {
            throw SignInError.invalidCredentials
        }

        // 2. Retrieve the current user's ID after successful sign-in.
        guard let userId = try await authRepository.getCurrentUserId() else {
            throw SignInError.signInFailed
        }

        // 3. Retrieve the user's profile information.
        do {
            let userBO = try await userProfileRepository.getUser(userId: userId)
            return userBO
        } catch {
            throw SignInError.signInFailed
        }
    }
}
