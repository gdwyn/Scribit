//
//  AuthViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var appUser: AppUser? = nil
    @Published var loadingState: LoadingState = .none
    
    func isFormValid(email: String, password: String) -> Bool {
        guard email.isValidEmail(), password.count > 6 else {
            return false
        }
        return true
    }
    
    func signUp(email: String, password: String) async {
        
        DispatchQueue.main.async {
            self.loadingState = .loading
        }
        
        if isFormValid(email: email, password: password) {
            do {
                let user = try await Supabase.shared.signUp(email: email, password: password)
                DispatchQueue.main.async {
                    self.appUser = user
                    self.loadingState = .success
                }
            } catch {
                DispatchQueue.main.async {
                    self.loadingState = .error("Could not sign up: \(error.localizedDescription)")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.loadingState = .error("Please enter a valid email and password")
            }
        }
    }
    
    func logIn(email: String, password: String) async {
            DispatchQueue.main.async {
                self.loadingState = .loading
            }

            if isFormValid(email: email, password: password) {
                do {
                    let user = try await Supabase.shared.LogIn(email: email, password: password)
                    DispatchQueue.main.async {
                        self.appUser = user
                        self.loadingState = .success
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.loadingState = .error("Could not log in: \(error.localizedDescription)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingState = .error("Please enter a valid email and password")
                }
            }
        }
}

