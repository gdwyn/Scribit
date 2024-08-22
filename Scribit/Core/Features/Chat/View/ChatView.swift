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
    
    @Environment(\.dismiss) private var dismiss

    @State var appUser: AppUser?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Messages")
                    .font(.title.weight(.semibold))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical)
            switch chatVM.loadingState {
            case .none:
                EmptyView()
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .success:
                
                if chatVM.chatMessages.isEmpty {
                    Spacer()
                    EmptyMessageView()
                    Spacer()
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
                    .scrollPosition(id: $chatVM.selectedMessage, anchor: .bottom)
                    .onChange(of: chatVM.chatMessages) {
                        chatVM.selectedMessage = chatVM.chatMessages.last?.id
                    }
                    .animation(.snappy, value: chatVM.selectedMessage)
                    .refreshable {
                        Task {
                            await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                        }
                    }
                    
                }
            case .error(let string):
                Text(string)
            }
            
            ChatTextField()
        }
        .padding(.horizontal)
        .onAppear{
            chatVM.subscribeToChatMessages(canvasId: canvasVM.currentCanvas.id.uuidString)
            Task {
                chatVM.loadingState = .loading
                await chatVM.fetchChatMessages(for: canvasVM.currentCanvas.id)
                chatVM.loadingState = .success

                self.appUser = try await Supabase.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    ChatView()
}
