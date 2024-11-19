//
//  SignUpUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Enum representing errors that can occur during the sign-up process.
enum SignUpError: Error {
    /// Error when the username is not available.
    case usernameNotAvailable
    /// Error when the passwords do not match.
    case passwordsDoNotMatch
    /// Error when the sign-up process fails.
    case signUpFailed(message: String)
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
        print("SignUpUseCase: Starting sign-up process with params: \(params)")
        
        // 1. Check if the passwords match.
        guard params.password == params.repeatPassword else {
            print("SignUpUseCase: Passwords do not match.")
            throw SignUpError.passwordsDoNotMatch
        }
        print("SignUpUseCase: Passwords match.")

        // 2. Check if the username is available.
        print("SignUpUseCase: Checking username availability for: \(params.username)")
        let isUsernameAvailable = try await userRepository.checkUsernameAvailability(username: params.username)
        guard isUsernameAvailable else {
            print("SignUpUseCase: Username \(params.username) is not available.")
            throw SignUpError.usernameNotAvailable
        }
        print("SignUpUseCase: Username \(params.username) is available.")

        // 3. Sign up the user using the provided email and password.
        do {
            print("SignUpUseCase: Attempting to sign up with email: \(params.email)")
            let userId = try await authRepository.signUp(email: params.email, password: params.password)
            print("SignUpUseCase: Sign-up successful. User ID: \(userId)")

            // 4. Create the user profile in the UserProfileRepository.
            print("SignUpUseCase: Creating user profile with ID: \(userId)")
            let userBO = try await userRepository.createUser(data: CreateUserBO(
                userId: userId,
                fullname: params.fullname,
                username: params.username,
                email: params.email
            ))
            print("SignUpUseCase: User profile created successfully. UserBO: \(userBO)")
            return userBO
        } catch {
            let errorMessage = "Sign-up failed: \(error.localizedDescription)"
            print("SignUpUseCase: \(errorMessage)")
            throw SignUpError.signUpFailed(message: errorMessage)
        }
    }
}
