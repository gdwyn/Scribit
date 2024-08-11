//
//  ContentView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State var appUser: AppUser? = nil

    var body: some View {
        ZStack {
            if appUser != nil {
                HomeView(appUser: $appUser)
            } else {
                LoginView(appUser: $appUser)
            }
        }
        .onAppear {
            Task {
                self.appUser = try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    ContentView()
}
