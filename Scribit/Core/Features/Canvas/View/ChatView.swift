//
//  ChatView.swift
//  Scribit
//
//  Created by Godwin IE on 21/08/2024.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            List(canvasVM.chatMessages) { message in
                VStack {
                    
                }
            }
            HStack {
                TextField("Enter message", text: $messageText)
                Button("Send") {
                    Task {
                        await canvasVM.sendMessage(canvasId: canvasVM.currentCanvas.id.uuidString, message: messageText)
                        messageText = ""
                    }
                }
            }
            .padding()
        }
        .onAppear{
            canvasVM.subscribeToChatMessages(canvasId: canvasVM.currentCanvas.id.uuidString)
        }
    }
}


#Preview {
    ChatView()
}
