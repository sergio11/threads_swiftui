//
//  AuthService.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 19/7/24.
//

import Foundation
import Firebase

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: Created used \(result.user.uid)")
        } catch let error {
            print("DEBUG: Failed to crear user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: Created used \(result.user.uid)")
        } catch let error {
            print("DEBUG: Failed to crear user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
