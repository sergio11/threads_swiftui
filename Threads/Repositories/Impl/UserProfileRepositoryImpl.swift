//
//  UserProfileRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Class responsible for managing user profile-related operations.
///
/// The `UserProfileRepositoryImpl` class implements the `UserProfileRepository` protocol, providing methods
/// to handle operations such as updating user profiles, creating new users, retrieving user information,
/// checking username availability, fetching user suggestions, and managing follow/unfollow actions.
///
/// This implementation uses multiple dependencies:
/// - `UserDataSource`: Handles interaction with the user data storage system (e.g., Firestore).
/// - `StorageFilesDataSource`: Manages file storage operations such as uploading profile pictures.
/// - `UserMapper`: Converts between data transfer objects (DTO) and business objects (BO) for users.
/// - `AuthenticationRepository`: Handles authentication-related operations.
internal class UserProfileRepositoryImpl: UserProfileRepository {
    
    private let userDataSource: UserDataSource
    private let storageFilesDataSource: StorageFilesDataSource
    private let userMapper: UserMapper
    private let authenticationRepository: AuthenticationRepository
    
    /// Initializes an instance of `UserProfileRepositoryImpl`.
        ///
        /// - Parameters:
        ///   - userDataSource: The data source for user-related operations.
        ///   - storageFilesDataSource: The data source for file storage operations.
        ///   - userMapper: The mapper used to map user-related data objects.
        ///   - authenticationRepository: The repository for handling authentication operations.
    init(
        userDataSource: UserDataSource,
        storageFilesDataSource: StorageFilesDataSource,
        userMapper: UserMapper,
        authenticationRepository: AuthenticationRepository
    ) {
        self.userDataSource = userDataSource
        self.storageFilesDataSource = storageFilesDataSource
        self.userMapper = userMapper
        self.authenticationRepository = authenticationRepository
    }
    
    /// Updates the user profile with the provided information.
    ///
    /// This method performs the following tasks:
    /// 1. If a profile image is provided, it uploads the image to a storage service and gets the URL for the image.
    /// 2. It then calls the data source to update the user data using the provided information, including the new profile image URL (if any).
    /// 3. The updated user data is mapped from the DTO (Data Transfer Object) to the business object (UserBO) using the userMapper.
    ///
    /// - Parameter data: An `UpdateUserBO` object containing the updated user information such as fullname, bio, and profile image data.
    /// - Returns: A `UserBO` object representing the updated user profile.
    /// - Throws:
    ///   - Throws any error encountered during the image upload or user data update process.
    func updateUser(data: UpdateUserBO) async throws -> UserBO {
        do {
            // Step 1: Upload profile image if available
            var profileImageUrl: String? = nil
            if let selectedImage = data.selectedImage {
                profileImageUrl = try await storageFilesDataSource.uploadImage(imageData: selectedImage, type: .profile)
            }
            
            // Step 2: Update user data using the provided parameters
            let userData = try await userDataSource.updateUser(data: UpdateUserDTO(
                userId: data.userId,
                fullname: data.fullname,
                link: data.link,
                isPrivateProfile: data.isPrivateProfile,
                bio: data.bio,
                profileImageUrl: profileImageUrl
            ))
            
            // Step 3: Map the updated user data to UserBO
            return userMapper.map(UserDataMapper(userDTO: userData, authUserId: data.userId))
        } catch {
            print("Error in updateUser: \(error.localizedDescription)")
            throw UserProfileRepositoryError.updateProfileFailed(message: error.localizedDescription)
        }
    }
    

    /// Creates a new user in the system with the provided information.
    ///
    /// This method performs the following tasks:
    /// 1. It creates a new user in the system using the provided user information, such as user ID, email, fullname, and username.
    /// 2. The user data is then mapped from the DTO (Data Transfer Object) to the business object (UserBO) using the userMapper.
    ///
    /// - Parameter data: A `CreateUserBO` object containing the required information to create a new user, including user ID, email, fullname, and username.
    /// - Returns: A `UserBO` object representing the newly created user.
    /// - Throws:
    ///   - Throws any error encountered during the user creation process.
    func createUser(data: CreateUserBO) async throws -> UserBO {
        do {
            // Step 1: Create a new user with the provided data
            let userData = try await userDataSource.createUser(data: CreateUserDTO(
                userId: data.userId,
                email: data.email,
                fullname: data.fullname,
                username: data.username
            ))
            
            // Step 2: Map the created user data to UserBO
            return userMapper.map(UserDataMapper(userDTO: userData, authUserId: data.userId))
        } catch {
            print("Error in createUser: \(error.localizedDescription)")
            throw UserProfileRepositoryError.createUserFailed(message: error.localizedDescription)
        }
    }
    
    /// Fetches user data asynchronously based on the provided user ID.
    /// - Parameter userId: The ID of the user to retrieve.
    /// - Returns: A `User` object containing the user data.
    /// - Throws: An error if the user data cannot be retrieved.
    func getUser(userId: String) async throws -> UserBO {
        do {
            guard let authUserId = try await authenticationRepository.getCurrentUserId() else {
                throw UserProfileRepositoryError.generic(message: "Auth user id not found")
            }
            let userData = try await userDataSource.getUserById(userId: userId)
            return userMapper.map(UserDataMapper(userDTO: userData, authUserId: authUserId))
        } catch {
            print("Error in getUser: \(error.localizedDescription)")
            throw UserProfileRepositoryError.getUserFailed(message: error.localizedDescription)
        }
    }
    
    /// Fetches user suggestions asynchronously for the provided authenticated user ID.
    /// - Parameter authUserId: The ID of the authenticated user for whom to fetch suggestions.
    /// - Returns: An array of `User` objects representing the fetched user suggestions.
    /// - Throws: An error if the user suggestions cannot be retrieved.
    func getSuggestions(authUserId: String) async throws -> [UserBO] {
        do {
            let userData = try await userDataSource.getSuggestions(authUserId: authUserId)
            let users = userData.map { userMapper.map(UserDataMapper(userDTO: $0, authUserId: authUserId)) }
            return users
        } catch {
            print("Error in getSuggestions: \(error.localizedDescription)")
            throw UserProfileRepositoryError.getSuggestionsFailed(message: error.localizedDescription)
        }
    }
    
    /// Checks the availability of a username asynchronously.
    /// - Parameter username: The username to check for availability.
    /// - Returns: A boolean value indicating whether the username is available or not.
    /// - Throws: An error if the availability check fails.
    func checkUsernameAvailability(username: String) async throws -> Bool {
        do {
            return try await userDataSource.checkUsernameAvailability(username: username)
        } catch {
            print("Error in checkUsernameAvailability: \(error.localizedDescription)")
            throw UserProfileRepositoryError.checkUsernameAvailabilityFailed(message: error.localizedDescription)
        }
    }
    
    /// Allows a user to follow or unfollow another user asynchronously.
    /// - Parameters:
    ///   - authUserId: The ID of the user performing the follow/unfollow action.
    ///   - targetUserId: The ID of the user to be followed or unfollowed.
    /// - Throws: An error if the operation fails, including errors specified in `UserDataSourceError`.
    func followUser(authUserId: String, targetUserId: String) async throws {
        do {
            try await userDataSource.followUser(authUserId: authUserId, targetUserId: targetUserId)
        } catch {
            print("Error in followUser: \(error.localizedDescription)")
            throw UserProfileRepositoryError.followUserFailed(message: error.localizedDescription)
        }
    }
    
    /// Searches for users based on a provided search term asynchronously.
    ///
    /// - Parameter searchTerm: A string representing the term to search for (e.g., username, fullname).
    /// - Returns: An array of `UserBO` objects that match the search criteria.
    /// - Throws: An error if the search operation fails.
    func searchUsers(searchTerm: String) async throws -> [UserBO] {
        do {
            guard let authUserId = try await authenticationRepository.getCurrentUserId() else {
                throw UserProfileRepositoryError.generic(message: "Auth user id not found")
            }
            let result = try await userDataSource.searchUsers(searchTerm: searchTerm)
            let users = result.map { userMapper.map(UserDataMapper(userDTO: $0, authUserId: authUserId)) }
            return users
        } catch {
            throw UserProfileRepositoryError.searchUsersFailed(message: error.localizedDescription)
        }
    }

    /// Retrieves the list of users that the user is following.
    /// - Parameter userId: The ID of the user.
    /// - Returns: An array of `UserBO` objects representing users that the user is following.
    /// - Throws: An error if the retrieval fails.
    func getFollowing(userId: String) async throws -> [UserBO] {
        do {
            let user = try await userDataSource.getUserById(userId: userId)
            return !user.following.isEmpty ? try await getUsersList(userId: userId, userIds: user.following): []
        } catch {
            throw UserProfileRepositoryError.followingFailed(message: error.localizedDescription)
        }
    }

    /// Retrieves the list of users who are following the user.
    /// - Parameter userId: The ID of the user.
    /// - Returns: An array of `UserBO` objects representing users who are following the user.
    /// - Throws: An error if the retrieval fails.
    func getFollowers(userId: String) async throws -> [UserBO] {
        do {
            let user = try await userDataSource.getUserById(userId: userId)
            return !user.followers.isEmpty ? try await getUsersList(userId: userId, userIds: user.followers): []
        } catch {
            throw UserProfileRepositoryError.followersFailed(message: error.localizedDescription)
        }
    }
    
    /// Retrieves the list of users (following or followers) for a given user.
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - userIds: An array of user IDs (either following or followers).
    /// - Returns: An array of `UserBO` objects representing the users.
    /// - Throws: A generic error if the retrieval fails.
    private func getUsersList(userId: String, userIds: [String]) async throws -> [UserBO] {
        guard let authUserId = try await authenticationRepository.getCurrentUserId() else {
            throw UserProfileRepositoryError.generic(message: "Auth user id not found")
        }
        let result = try await userDataSource.getUserByIdList(userIds: userIds)
        return result.map { userMapper.map(UserDataMapper(userDTO: $0, authUserId: authUserId)) }
    }
}

