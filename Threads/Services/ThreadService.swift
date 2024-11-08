//
//  ThreadService.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 1/8/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ThreadService {
    
    static func uploadThread(_ thread: ThreadBO) async throws {
        guard let threadData = try? Firestore.Encoder().encode(thread) else { return }
        try await Firestore.firestore().collection("threads").addDocument(data: threadData)
    }
    
    static func fetchThreads() async throws -> [ThreadBO] {
        let snapshot = try await Firestore
            .firestore()
            .collection("threads")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: ThreadBO.self) })
    }
    
    static func fetchUserThreads(uid: String) async throws -> [ThreadBO] {
        let snapshot = try await Firestore
            .firestore()
            .collection("threads")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let threads = snapshot.documents.compactMap({ try? $0.data(as: ThreadBO.self) })
        return threads.sorted(by: { $0.timestamp > $1.timestamp })
    }
}
