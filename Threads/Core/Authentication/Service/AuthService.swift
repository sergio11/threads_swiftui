//
//  AuthService.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 19/7/24.
//

import Foundation
import Firebase

class AuthService {
    
    static let shared = AuthService()
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("DEBUG: Created used \(result.user.uid)")
        } catch let error {
            print("DEBUG: Failed to crear user with error \(error.localizedDescription)")
        }
    }
}
