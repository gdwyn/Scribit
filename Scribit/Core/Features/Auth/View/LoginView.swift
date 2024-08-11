//
//  LoginView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    
    @Binding var appUser: AppUser?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 14) {
                    Image("scribitlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 58, height: 58)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text("Log in")
                            .font(.title)
                        
                        Text("Welcome! Enter your details")
                            .foregroundStyle(.gray)
                    }
                    
                }
                .padding(.bottom, 18)
                
                VStack(spacing: 20) {
                    AppTextField(title: "Email", placeHolder: "Enter your email", text: $email)
                    
                    AppPasswordField(title: "Password", placeHolder: "Enter your password", password: $password)
                }
                
                VStack(spacing: 18) {
                    Button {
                        Task {
                            do {
                                let appUser = try await authVM.logIn(email: email, password: password)
                                self.appUser = appUser
                            } catch {
                                print("issue with sign in")
                            }
                        }
                    } label: {
                        Text("Log in")
                            .padding()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(.accent, in: RoundedRectangle(cornerRadius: 18))
                        
                    }
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.gray)
                        
                        Button("Sign up") {
                            showSignUp = true
                        }
                        .sheet(isPresented: $showSignUp) {
                            SignupView(appUser: $appUser)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(appUser: .constant(.init(uid: "1234", email: nil)))
}
