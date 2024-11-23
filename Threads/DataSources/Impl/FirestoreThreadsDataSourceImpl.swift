//
//  FirestoreThreadsDataSourceImpl.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Firestore implementation of `ThreadsDataSource`.
internal class FirestoreThreadsDataSourceImpl: ThreadsDataSource {
    
    private let threadsCollection = "threads"
    private let db = Firestore.firestore()

    /// Uploads a new thread to Firestore.
    /// - Parameter dto: The `CreateThreadDTO` object containing thread details.
    /// - Returns: A `ThreadDTO` representing the uploaded thread.
    func uploadThread(_ dto: CreateThreadDTO) async throws -> ThreadDTO {
        let documentReference = Firestore
            .firestore()
            .collection(threadsCollection)
            .document(dto.threadId)
        
        do {
            try await documentReference.setData(dto.asDictionary())  // Upload the thread
            return try await getThreadById(threadId: dto.threadId)   // Fetch the thread after upload
        } catch {
            print("Upload failed: \(error.localizedDescription)")
            throw ThreadsDataSourceError.uploadFailed  // Custom error for upload failure
        }
    }

    /// Fetches all threads from Firestore, ordered by timestamp.
    /// - Returns: An array of `ThreadDTO` objects.
    func fetchThreads() async throws -> [ThreadDTO] {
        do {
            let snapshot = try await db
                .collection(threadsCollection)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            // Map Firestore documents to `ThreadDTO`
            let threads = snapshot.documents.compactMap { document in
                try? document.data(as: ThreadDTO.self)
            }
            
            if threads.isEmpty {
                throw ThreadsDataSourceError.fetchThreadsFailed // Custom error if no threads are found
            }
            
            return threads
        } catch {
            print("Error fetching threads: \(error.localizedDescription)")
            throw ThreadsDataSourceError.fetchThreadsFailed  // Custom error if the operation fails
        }
    }

    /// Fetches threads created by a specific user.
    /// - Parameter uid: The user ID whose threads are to be fetched.
    /// - Returns: An array of `ThreadDTO` objects, sorted by timestamp.
    func fetchUserThreads(uid: String) async throws -> [ThreadDTO] {
        do {
            let snapshot = try await db
                .collection(threadsCollection)
                .whereField("ownerUid", isEqualTo: uid)
                .getDocuments()
            
            let threads = snapshot.documents.compactMap { document in
                try? document.data(as: ThreadDTO.self)
            }
            
            if threads.isEmpty {
                throw ThreadsDataSourceError.fetchUserThreadsFailed // Custom error if no user threads are found
            }
            
            // Sort threads by timestamp in descending order
            return threads.sorted { $0.timestamp > $1.timestamp }
        } catch {
            print("Error fetching user's threads: \(error.localizedDescription)")
            throw ThreadsDataSourceError.fetchUserThreadsFailed  // Custom error if the operation fails
        }
    }

    /// Fetches a thread by its ID.
    /// - Parameter threadId: The ID of the thread to fetch.
    /// - Returns: A `ThreadDTO` representing the thread.
    private func getThreadById(threadId: String) async throws -> ThreadDTO {
        do {
            let documentSnapshot = try await db
                .collection(threadsCollection)
                .document(threadId)
                .getDocument()
            
            guard let thread = try? documentSnapshot.data(as: ThreadDTO.self) else {
                print("Thread not found with ID: \(threadId)")
                throw ThreadsDataSourceError.threadNotFound  // Custom error if thread is not found
            }
            return thread
        } catch {
            print("Error getting thread by ID: \(error.localizedDescription)")
            throw ThreadsDataSourceError.invalidThreadId(message: "Invalid thread ID: \(threadId)")  // Custom error if invalid thread ID
        }
    }
    
    /// Like or dislike a thread.
    /// - Parameters:
    ///   - threadId: The ID of the thread to like/dislike.
    ///   - userId: The ID of the user performing the action.
    /// - Returns: A boolean indicating whether the action was successful or not.
    func likeThread(threadId: String, userId: String) async throws -> Bool {
        let threadRef = db.collection(threadsCollection).document(threadId)

        do {
            // Get the current thread data
            let threadSnapshot = try await threadRef.getDocument()
                
            guard var thread = try? threadSnapshot.data(as: ThreadDTO.self) else {
                print("Thread not found")
                throw ThreadsDataSourceError.threadNotFound
            }

            // Check if the user has already liked the thread
            if thread.likedBy.contains(userId) {
                // User has already liked, so we remove the like (dislike)
                let newLikedBy = thread.likedBy.filter { $0 != userId }
                let newLikesCount = thread.likes - 1

                // Update the thread document in Firestore
                try await threadRef.updateData([
                    "likedBy": newLikedBy,
                    "likes": newLikesCount
                ])
            } else {
                // User has not liked, so we add the like
                let newLikedBy = thread.likedBy + [userId]
                let newLikesCount = thread.likes + 1

                // Update the thread document in Firestore
                try await threadRef.updateData([
                    "likedBy": newLikedBy,
                    "likes": newLikesCount
                ])
            }

            return true
        } catch {
            print("Error liking thread: \(error.localizedDescription)")
            throw ThreadsDataSourceError.likeFailed
        }
    }
}
