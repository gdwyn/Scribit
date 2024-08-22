//
//  ScribitApp.swift
//  Scribit
//
//  Created by Godwin IE on 05/08/2024.
//

import SwiftUI

@main
struct ScribitApp: App {
    @StateObject var authVM = AuthViewModel()
    @StateObject var canvasVM = CanvasViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var chatVM = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(canvasVM)
                .environmentObject(authVM)
                .environmentObject(homeVM)
                .environmentObject(chatVM)
        }
    }
}
