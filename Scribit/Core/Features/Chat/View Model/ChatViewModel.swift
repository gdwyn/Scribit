//
//  ChatViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import Foundation
import Supabase

class ChatViewModel: ObservableObject {
    @Published var chatMessages = [ChatMessage]()
    @Published var loadingState: LoadingState = .none
    @Published var messageText: String = ""
    @Published var selectedMessage: UUID? = nil
    @Published var hasNewMessages: Bool = false
    @Published var subscribedToChats: Bool = false
    
    func fetchChatMessages(for canvasId: UUID) async {
        do {
            let query = try? await Supabase.client
                .from("messages")
                .select()
                .eq("canvasId", value: canvasId.uuidString)
                .order("timestamp", ascending: true)
                .execute()
            
            guard let data = query?.data,
                  let result = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                print("No chat data fetched or data format is incorrect")
                return
            }
            
            var fetchedMessages: [ChatMessage] = []
            for item in result {
                if let idString = item["id"] as? String,
                   let id = UUID(uuidString: idString),
                   let userId = item["userId"] as? String,
                   let message = item["message"] as? String,
                   let timestampString = item["timestamp"] as? String,
                   let timestamp = ISO8601DateFormatter().date(from: timestampString) {
                    let chatMessage = ChatMessage(id: id, canvasId: canvasId.uuidString, userId: userId, message: message, timestamp: timestamp)
                    fetchedMessages.append(chatMessage)
                }
            }
            
            let messages = fetchedMessages

            DispatchQueue.main.async {
                self.chatMessages = messages
            }
            
        } catch {
            print("Error fetching chat messages: \(error)")
        }
    }

    func sendMessage(canvasId: String, message: String) async {
        do {
            let currentUser = try await Supabase.shared.getCurrentSession()
            let newMessage = ChatMessage(id: UUID(), canvasId: canvasId, userId: currentUser.email ?? "Email address", message: message, timestamp: Date())
            
            try await Supabase.client
                .from("messages")
                .insert([
                    "id": newMessage.id.uuidString,
                    "canvasId": canvasId,
                    "userId": newMessage.userId,
                    "message": newMessage.message,
                    "timestamp": ISO8601DateFormatter().string(from: newMessage.timestamp)
                ])
                .execute()
            
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    func subscribeToChatMessages(canvasId: String) async {
        let channel = Supabase.client.channel("public:messages")
        
        Task {
            
            let chatUpdates = channel.postgresChange(
                AnyAction.self,
                schema: "public",
                table: "messages",
                filter: "canvasId=eq.\(canvasId)"
            )
            
            await channel.subscribe()
            
            for await change in chatUpdates {
                switch change {
                case .insert(let action):
                    if let idJSON = action.record["id"],
                       case let .string(idString) = idJSON,
                       let id = UUID(uuidString: idString),
                       let userIdJSON = action.record["userId"],
                       case let .string(userId) = userIdJSON,
                       let messageJSON = action.record["message"],
                       case let .string(message) = messageJSON,
                       let timestampJSON = action.record["timestamp"],
                       case let .string(timestampString) = timestampJSON,
                       let timestamp = ISO8601DateFormatter().date(from: timestampString) {
                        
                        let newMessage = ChatMessage(
                            id: id,
                            canvasId: canvasId,
                            userId: userId,
                            message: message,
                            timestamp: timestamp
                        )
                        
                        DispatchQueue.main.async {
                            self.chatMessages.append(newMessage)
                            self.hasNewMessages = true
                        }
                    }
                default:
                    break
                }
            }
        }
    }

//    func unsubscribe() async {
//        let channel = Supabase.client.channel("public:messages")
//        await Supabase.client.removeChannel(channel)
//    }
    
}
