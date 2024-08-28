//
//  SignupView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
        
    var body: some View {
        ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 14) {
                Image("scribitlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Create an account")
                        .font(.title)
                    
                    Text("Enter your details to sign up")
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
                            let appUser = try await authVM.signUp(email: email, password: password)
                            authVM.appUser = appUser
                            dismiss()
                        } catch {
                            print("issue with sign up")
                        }
                    }
                } label: {
                    Text("Sign up")
                        .padding()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.accent, in: RoundedRectangle(cornerRadius: 18))
                    
                }
                HStack {
                    Text("Already have an account?")
                        .foregroundStyle(.gray)
                    
                    Button("Log in") {
                        dismiss()
                    }
                    
                }
            }
        }
        .padding()
    }
    }
}

#Preview {
    SignupView()
}
