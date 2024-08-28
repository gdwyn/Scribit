//
//  ProfileView.swift
//  Scribit
//
//  Created by Godwin IE on 15/08/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image("userprofile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                
                VStack(spacing: 8) {
                    Text(authVM.appUser?.email ?? "user")
                    
                    Text(authVM.appUser?.uid ?? "user id")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    Button {
                        
                        Task {
                            do {
                                try await Supabase.shared.signOut()
                                authVM.appUser = nil
                            } catch {
                                print("unable to sign out")
                            }
                        }
                        
                        dismiss()
                    } label: {
                        Text("Log out")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.red.opacity(0.06), in: .capsule)
                            .foregroundStyle(.red)
                            .padding(14)
                    }
                }
                
            }
            .padding(.top, 24)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
