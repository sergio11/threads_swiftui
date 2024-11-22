//
//  SearchUsersUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

/// Enum representing errors that can occur during the search for users.
enum SearchUsersError: Error {
    /// Error indicating that the user search operation failed.
    /// - Parameter message: A detailed message describing the failure.
    case searchFailed(message: String)
}

/// Parameters required for executing a user search operation.
struct SearchUsersParams {
    /// The search term used to find users.
    let term: String
}

/// Use case responsible for searching users based on a provided term.
///
/// The `SearchUsersUseCase` orchestrates the user search operation by interacting
/// with the `UserProfileRepository` to find users whose data matches the given search term.
/// It also handles potential errors during the search process.
struct SearchUsersUseCase {
    /// The repository responsible for user profile-related operations.
    let userRepository: UserProfileRepository
    
    /// The repository responsible for authentication-related operations.
    let authRepository: AuthenticationRepository
    
    /// Executes the user search operation.
    ///
    /// - Parameter params: An instance of `SearchUsersParams` containing the search term.
    /// - Returns: An array of `UserBO` objects representing the users found during the search.
    /// - Throws:
    ///   - `SearchUsersError.searchFailed`: If the search operation fails, providing a detailed error message.
    func execute(params: SearchUsersParams) async throws -> [UserBO] {
        do {
            // Perform the search using the user repository and return the results.
            return try await userRepository.searchUsers(searchTerm: params.term)
        } catch {
            // Wrap any thrown error in a `SearchUsersError.searchFailed` with a descriptive message.
            throw SearchUsersError.searchFailed(message: error.localizedDescription)
        }
    }
}
