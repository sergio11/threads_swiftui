//
//  FetchUserConnectionsUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import Foundation

enum FetchUserConnectionsError: Error {
    case fetchFailed
    case fetchFollowersFailed
    case fetchFollowingFailed
}

/// Struct to encapsulate the parameters for fetching user connections (followers or following).
struct FetchUserConnectionsParams {
    let userId: String
    let connectionType: UserConnectionType
}

/// Enum to represent whether to fetch followers or following
enum UserConnectionType {
    case followers
    case following
}

/// An entity responsible for fetching a user's followers or following.
struct FetchUserConnectionsUseCase {
    let userProfileRepository: UserProfileRepository
    let authRepository: AuthenticationRepository
    
    /// Executes the fetch operation for followers or following asynchronously.
    /// - Parameter params: The parameters containing the userId and connection type (followers or following).
    /// - Returns: A list of `UserBO` objects representing either followers or following for the user.
    /// - Throws: An error if the fetch operation fails.
    func execute(params: FetchUserConnectionsParams) async throws -> [UserBO] {
        guard let authUserId = try await authRepository.getCurrentUserId() else {
            throw FetchUserConnectionsError.fetchFailed
        }
        
        do {
            // Fetch either followers or following based on the connectionType
            switch params.connectionType {
            case .followers:
                let followers = try await userProfileRepository.getFollowers(userId: params.userId)
                return followers
            case .following:
                let following = try await userProfileRepository.getFollowing(userId: params.userId)
                return following
            }
        } catch {
            // Handle specific cases of fetching followers or following
            if params.connectionType == .followers {
                throw FetchUserConnectionsError.fetchFollowersFailed
            } else {
                throw FetchUserConnectionsError.fetchFollowingFailed
            }
        }
    }
}
