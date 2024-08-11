//
//  HomeView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI

struct HomeView: View {
    @Binding var appUser: AppUser?

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image("scribempty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84)
                
                VStack(spacing: 6) {
                    Text("Hi! Let's scrib")
                        .font(.title3)
                    Text("Click the button below to start scribbing on your canvas")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .frame(width: 220)
                        .multilineTextAlignment(.center)
                }
                
                NavigationLink(destination: CanvasView()){
                    Text("Start Scribbing")
                        .padding()
                        .foregroundStyle(.white)
                        .background(.accent, in: RoundedRectangle(cornerRadius: 18))
                }
                
            }
            .padding(.bottom, 60)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            do {
                                try await AuthManager.shared.signOut()
                                self.appUser = nil
                            } catch {
                                print("unable to sign out")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .rotationEffect(.degrees(180))
                            Text("Log out")
                        }
                        .font(.callout)
                        .foregroundStyle(.gray)
                    }
                }
            }
            
        }
    }
}

#Preview {
    HomeView(appUser: .constant(.init(uid: "1234", email: nil)))
        .environmentObject(AuthViewModel())
}
