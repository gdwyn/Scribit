//
//  AuthViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import Foundation

class AuthViewModel: ObservableObject {
    func isFormValid(email: String, password: String) -> Bool {
            guard email.isValidEmail(), password.count > 6 else {
                return false
            }
            return true
        }
    
    func signUp(email: String, password: String) async throws -> AppUser {
        if isFormValid(email: email, password: password) {
                    return try await Supabase.shared.signUp(email: email, password: password)
        } else {
            print("registion form is invalid")
            throw NSError()
        }
    }
    
    func logIn(email: String, password: String) async throws -> AppUser {
        if isFormValid(email: email, password: password) {
            return try await Supabase.shared.LogIn(email: email, password: password)
        } else {
            print("sign in form is invalid")
            throw NSError()
        }
    }
}

