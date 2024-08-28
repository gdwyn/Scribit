//
//  ContentView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        ZStack {
            if authVM.appUser != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            Task {
                authVM.appUser = try await Supabase.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    ContentView()
}
