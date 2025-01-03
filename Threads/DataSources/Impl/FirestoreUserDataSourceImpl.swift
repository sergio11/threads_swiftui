//
//  FirestoreUserDataSourceImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore

/// A data source responsible for managing user data in Firestore.
internal class FirestoreUserDataSourceImpl: UserDataSource {
    
    private let usersCollection = "threads_users"
    
    /// Saves user data to Firestore.
        /// - Parameters:
        ///   - data: The data of the user to be saved.
        /// - Returns: A `UserDTO` object representing the saved user.
        /// - Throws: An error if the operation fails.
    func updateUser(data: UpdateUserDTO) async throws -> UserDTO {
        let documentReference = Firestore
            .firestore()
            .collection(usersCollection)
            .document(data.userId)
        do {
            // Save user data to Firestore
            try await documentReference.setData(data.asDictionary(), merge: true)
            // Return the saved user data by fetching it from Firestore
            return try await getUserById(userId: data.userId)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    /// Creates a new user in Firestore with the provided user data.
    /// - Parameter data: The data of the user to be created.
    /// - Returns: A `UserDTO` object representing the created user.
    /// - Throws: An error if the operation fails.
    func createUser(data: CreateUserDTO) async throws -> UserDTO {
        let documentReference = Firestore
                .firestore()
                .collection(usersCollection)
                .document(data.userId)
        do {
            // Save user data to Firestore
            try await documentReference.setData(data.asDictionary())
            // Return the saved user data by fetching it from Firestore
            return try await getUserById(userId: data.userId)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    /// Retrieves user data from Firestore based on the provided user ID.
        /// - Parameter userId: The ID of the user to retrieve.
        /// - Returns: A `UserDTO` object containing the user data.
        /// - Throws: An error if the user data is not found or if the operation fails.
    func getUserById(userId: String) async throws -> UserDTO {
        let documentSnapshot = try await Firestore
            .firestore()
            .collection(usersCollection)
            .document(userId)
            .getDocument()
        // Attempt to decode the document data into a UserDTO object
        guard let userData = try? documentSnapshot.data(as: UserDTO.self) else {
            throw UserDataSourceError.userNotFound
        }
        return userData
    }
    
    /// Retrieves user data for a list of user IDs asynchronously.
    /// - Parameter userIds: An array of user IDs to retrieve user data for.
    /// - Returns: An array of `UserDTO` objects containing the user data.
    /// - Throws: An error if the operation fails, including errors specified in `UserDataSourceError`.
    func getUserByIdList(userIds: [String]) async throws -> [UserDTO] {
        let querySnapshot = try await Firestore
            .firestore()
            .collection(usersCollection)
            .whereField("userId", in: userIds)
            .getDocuments()
        var usersData: [UserDTO] = []
        for document in querySnapshot.documents {
            if let userData = try? document.data(as: UserDTO.self) {
                usersData.append(userData)
            }
        }
        return usersData
    }
    
    /// Retrieves suggestions for users based on the authenticated user ID asynchronously.
    /// - Parameter authUserId: The ID of the authenticated user.
    /// - Returns: An array of `UserDTO` objects representing user suggestions.
    /// - Throws: An error if the operation fails, including errors specified in `UserDataSourceError`.
    func getSuggestions(authUserId: String) async throws -> [UserDTO] {
        let documentSnapshot = try await Firestore
            .firestore()
            .collection(usersCollection)
            .document(authUserId)
            .getDocument()
        guard let userData = try? documentSnapshot.data(as: UserDTO.self) else {
            throw UserDataSourceError.userNotFound
        }
        let allIds = [authUserId] + userData.followers + userData.following
        let querySnapshot = try await Firestore
            .firestore()
            .collection(usersCollection)
            .whereField("userId", notIn: allIds)
            .getDocuments()
        var suggestions: [UserDTO] = []
        for document in querySnapshot.documents {
            if let userData = try? document.data(as: UserDTO.self) {
                suggestions.append(userData)
            }
        }
        return suggestions
    }
    
    /// Checks the availability of a username asynchronously.
    /// - Parameter username: The username to check for availability.
    /// - Returns: A Boolean value indicating whether the username is available.
    /// - Throws: An error if the operation fails, including errors specified in `UserDataSourceError`.
    func checkUsernameAvailability(username: String) async throws -> Bool {
        let querySnapshot = try await Firestore
            .firestore()
            .collection(usersCollection)
            .whereField("username", isEqualTo: username)
            .getDocuments()
        return querySnapshot.isEmpty
    }
    
    /// Allows a user to follow or unfollow another user asynchronously.
    /// - Parameters:
    ///   - authUserId: The ID of the user performing the follow/unfollow action.
    ///   - targetUserId: The ID of the user to be followed or unfollowed.
    /// - Throws: An error if the operation fails, including errors specified in `UserDataSourceError`.
    func followUser(authUserId: String, targetUserId: String) async throws {
        let firestore = Firestore.firestore()
        
        // Fetch the user and target user documents from Firestore
        let authUserRef = firestore.collection(usersCollection).document(authUserId)
        let targetUserRef = firestore.collection(usersCollection).document(targetUserId)
        
        do {
            // Fetch current user data
            let authUserSnapshot = try await authUserRef.getDocument()
            guard var authUser = try? authUserSnapshot.data(as: UserDTO.self) else {
                throw UserDataSourceError.userNotFound
            }
            
            // Fetch target user data
            let targetUserSnapshot = try await targetUserRef.getDocument()
            guard var targetUser = try? targetUserSnapshot.data(as: UserDTO.self) else {
                throw UserDataSourceError.userNotFound
            }
            
            // Check if the user is already following the target user
            let isCurrentlyFollowing = authUser.following.contains(targetUserId)
            
            if isCurrentlyFollowing {
                // Unfollow the user
                authUser.following.removeAll { $0 == targetUserId }
                targetUser.followers.removeAll { $0 == authUserId }
                authUser.followingCount -= 1
                targetUser.followersCount -= 1
            } else {
                // Follow the user
                authUser.following.append(targetUserId)
                targetUser.followers.append(authUserId)
                authUser.followingCount += 1
                targetUser.followersCount += 1
            }
            
            
            // Update the thread document in Firestore
            try await authUserRef.updateData([
                "following": authUser.following,
                "followingCount": authUser.followingCount
            ])
            
            try await targetUserRef.updateData([
                "followers": targetUser.followers,
                "followersCount": targetUser.followersCount
            ])
            
        } catch {
            print("Error following/unfollowing user: \(error.localizedDescription)")
            throw UserDataSourceError.saveFailed
        }
    }
    
    /// Searches for users based on a provided search term in their username or fullname asynchronously.
    /// - Parameter searchTerm: A string representing the term to search for (e.g., username, fullname).
    /// - Returns: An array of `UserDTO` objects that match the search criteria.
    /// - Throws: An error if the search operation fails, including errors specified in `UserDataSourceError`.
    func searchUsers(searchTerm: String) async throws -> [UserDTO] {
        let firestore = Firestore.firestore()
        
        do {
            // Query for users where the username matches the search term
            let usernameQuery = firestore
                .collection(usersCollection)
                .whereField("username", isGreaterThanOrEqualTo: searchTerm)
                .whereField("username", isLessThanOrEqualTo: searchTerm + "\u{f8ff}")
            
            // Query for users where the fullname matches the search term
            let fullnameQuery = firestore
                .collection(usersCollection)
                .whereField("fullname", isGreaterThanOrEqualTo: searchTerm)
                .whereField("fullname", isLessThanOrEqualTo: searchTerm + "\u{f8ff}")
            
            // Execute both queries concurrently
            async let usernameSnapshot = usernameQuery.getDocuments()
            async let fullnameSnapshot = fullnameQuery.getDocuments()
            
            // Decode documents into UserDTO objects
            let usernameResults = try await usernameSnapshot.documents.compactMap { try? $0.data(as: UserDTO.self) }
            let fullnameResults = try await fullnameSnapshot.documents.compactMap { try? $0.data(as: UserDTO.self) }
            
            // Combine and remove duplicates
            let combinedResults = Array(Set(usernameResults + fullnameResults))
            
            // Return the unique list of users
            return combinedResults
        } catch {
            print("Error searching for users: \(error.localizedDescription)")
            throw UserDataSourceError.searchFailed(message: "Failed to search for users")
        }
    }
}
