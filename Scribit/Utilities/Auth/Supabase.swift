//
//  AuthManager.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}

class Supabase {
    
    static let shared = Supabase()
    
    private init() {}
    
    static let client = SupabaseClient(supabaseURL: URL(string: "https://hnqwxhpjzhqtlpmegiur.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhucXd4aHBqemhxdGxwbWVnaXVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMxMjY3MzAsImV4cCI6MjAzODcwMjczMH0.tVssRs8CdxN5WYWOsg7w7xJTRXOzu47M9DlF5R4IGRM")
    
    func getCurrentSession() async throws -> AppUser {
        let session = try await Supabase.client.auth.session
        print(session)
        print(session.user.id)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signUp(email: String, password: String) async throws -> AppUser {
        let regAuthResponse = try await Supabase.client.auth.signUp(email: email, password: password)
        guard let session = regAuthResponse.session else {
            print("no session when registering user")
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func LogIn(email: String, password: String) async throws -> AppUser {
        let session = try await Supabase.client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        
    }
    
    func signOut() async throws {
        try await Supabase.client.auth.signOut()
    }
}
