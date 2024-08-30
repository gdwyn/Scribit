//
//  ContentView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showSplashScreen = true

    var body: some View {
        if showSplashScreen {
            SplashView(showSplashScreen: $showSplashScreen)
        } else {
            ZStack {
                if authVM.appUser != nil {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
