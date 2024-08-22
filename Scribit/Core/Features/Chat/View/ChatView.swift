//
//  ChatView.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var canvasVM : CanvasViewModel
    @EnvironmentObject var chatVM : ChatViewModel
    @State var appUser: AppUser?

    @State private var messageText: String = ""
    @State var selectedMessage: UUID? = nil

    var body: some View {
        VStack (alignment: .leading) {
            
            if chatVM.chatMessages.isEmpty {
                
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack (alignment: .trailing, spacing: 24) {
                        ForEach(chatVM.chatMessages) { message in
                            ChatBubble(appUser: appUser, message: message)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .scrollTargetLayout()
                }
                .padding(.bottom)
                .animation(.bouncy, value: chatVM.chatMessages)
                .defaultScrollAnchor(.bottom)
                .scrollBounceBehavior(.basedOnSize)
                .scrollPosition(id: $selectedMessage, anchor: .bottom)
                .onChange(of: chatVM.chatMessages) {
                    selectedMessage = chatVM.chatMessages.last?.id
                }
                .animation(.snappy, value: selectedMessage)
                .refreshable {
                    Task {
                        await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                    }
                }
                
            }
            
            HStack {
                TextField("Write something...", text: $messageText)
                    .padding(8)
                
                if !messageText.isEmpty {
                    Button(action: {
                        Task {
                            await chatVM.sendMessage(canvasId: canvasVM.currentCanvas.id.uuidString, message: messageText)
                            messageText = ""
                            await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                        }
                    }, label: {
                        Image(systemName: "paperplane.circle.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                    })
                    .transition(.opacity.combined(with: .scale))
                }

            }
            .padding(8)
            .background(.gray.opacity(0.06), in: Capsule())
            .background(
                Rectangle()
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .edgesIgnoringSafeArea(.bottom)
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .padding(.horizontal)
        .onAppear{
            chatVM.subscribeToChatMessages(canvasId: canvasVM.currentCanvas.id.uuidString)
            Task {
                await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                self.appUser = try await Supabase.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    ChatView()
}
