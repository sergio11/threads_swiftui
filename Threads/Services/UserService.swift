//
//  UserService.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: UserBO?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore()
            .collection("threads_users")
            .document(uid)
            .getDocument()
        let user = try snapshot.data(as: UserBO.self)
        self.currentUser = user
    }
    
    static func fetchUsers() async throws -> [UserBO] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        let snapshot = try await Firestore.firestore()
            .collection("threads_users")
            .getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: UserBO.self)})
        return users.filter({ $0.id != currentUid })
    }
    
    static func fetchUser(withUid uid: String) async throws -> UserBO {
        let snapshot = try await Firestore.firestore()
            .collection("threads_users")
            .document(uid)
            .getDocument()
        return try snapshot.data(as: UserBO.self)
    }
    
    func reset() {
        self.currentUser = nil
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("threads_users")
            .document(currentUid)
            .updateData([
                "profileImageUrl": imageUrl
            ])
        self.currentUser?.profileImageUrl = imageUrl
    }
}
