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
                
                VStack(spacing: 12) {
                    Button {
                        Task {
                            await authVM.logIn(email: email, password: password)
                        }
                    } label: {
                            switch authVM.loadingState {
                            case .loading:
                                ProgressView()
                                    .padding()
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(.accent, in: RoundedRectangle(cornerRadius: 18))
                                
                            default:
                                Text("Log in")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(.accent, in: RoundedRectangle(cornerRadius: 18))
                                
                            }
                    }
                    
                    switch authVM.loadingState {
                    case .error(let errorMessage):
                        Text(errorMessage)
                            .foregroundStyle(.accent)
                    default:
                        EmptyView()
                    }
                                        
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.gray)
                        
                        Button("Sign up") {
                            showSignUp = true
                        }
                        .sheet(isPresented: $showSignUp) {
                            SignupView()
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
