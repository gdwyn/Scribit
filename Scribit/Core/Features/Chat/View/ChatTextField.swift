//
//  ChatTextField.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import SwiftUI

struct ChatTextField: View {
    @EnvironmentObject var canvasVM : CanvasViewModel
    @EnvironmentObject var chatVM : ChatViewModel
    
    var body: some View {
        HStack {
            TextField("Write something...", text: $chatVM.messageText)
                .padding(6)
            
            if !chatVM.messageText.isEmpty {
                Button {
                    Task {
                        await chatVM.sendMessage(canvasId: canvasVM.currentCanvas.id.uuidString, message: chatVM.messageText)
                        chatVM.messageText = ""
                        await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(.accent)
                        .font(.title)
                }
                .transition(.opacity.combined(with: .scale))
            }

        }
        .padding(8)
        .background(.gray.opacity(0.06), in: Capsule())
        .padding(.bottom)
    }
}

#Preview {
    ChatTextField()
}
