//
//  UserProfileRepositoryImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// Class responsible for managing user profile-related operations.
internal class UserProfileRepositoryImpl: UserProfileRepository {
    
    private let userDataSource: UserDataSource
    private let storageFilesDataSource: StorageFilesDataSource
    private let userMapper: UserMapper
    
    /// Initializes an instance of `UserProfileRepositoryImpl`.
        /// - Parameters:
        ///   - userDataSource: The data source for user-related operations.
        ///   - storageFilesDataSource: The data source for file storage operations.
        ///   - userMapper: The mapper used to map user-related data objects.
    init(userDataSource: UserDataSource, storageFilesDataSource: StorageFilesDataSource, userMapper: UserMapper) {
        self.userDataSource = userDataSource
        self.storageFilesDataSource = storageFilesDataSource
        self.userMapper = userMapper
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
            return userMapper.map(userData)
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
            return userMapper.map(userData)
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
            let userData = try await userDataSource.getUserById(userId: userId)
            return userMapper.map(userData)
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
            let users = userData.map { userMapper.map($0) }
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
}

