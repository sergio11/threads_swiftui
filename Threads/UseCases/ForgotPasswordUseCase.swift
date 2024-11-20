//
//  ForgotPasswordUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/11/24.
//

import Foundation

/// Enum representing possible errors that can occur during the forgot password process.
enum ForgotPasswordError: Error {
    /// Error indicating that the provided email is invalid or not associated with an account.
    case invalidEmail
    
    /// Error indicating that sending the password reset email failed.
    case forgotPasswordFailed
}

/// A structure to hold the parameters required for the forgot password use case.
struct ForgotPasswordParams {
    var email: String  // The email address that the user provided to reset the password.
}

/// A use case responsible for handling the forgot password logic.
struct ForgotPasswordUseCase {
    let authRepository: AuthenticationRepository  // Repository responsible for interacting with the authentication system.

    /// Executes the forgot password process by sending a password reset email.
    /// - Parameter params: The parameters for the forgot password process (specifically the user's email).
    /// - Throws: A `ForgotPasswordError` if any issue occurs during the process.
    /// - Returns: A `Bool` indicating whether the password reset email was sent successfully.
    func execute(params: ForgotPasswordParams) async throws -> Bool {
        // 1. Attempt to send a password reset email with the provided email address.
        print("ForgotPasswordUseCase: Attempting to send password reset email to: \(params.email)")
        
        do {
            // Trying to send the reset password email by calling the repository method
            try await authRepository.forgotPassword(email: params.email)
            print("ForgotPasswordUseCase: Password reset email sent successfully.")
            return true  // If the email is sent successfully, return true.
        } catch {
            // If the password reset email fails to send, print the error and throw a specific error.
            print("ForgotPasswordUseCase: Failed to send password reset email with error: \(error.localizedDescription)")
            throw ForgotPasswordError.forgotPasswordFailed  // Throw an error if the process fails.
        }
    }
}


