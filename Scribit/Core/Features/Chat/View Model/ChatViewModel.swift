//
//  ChatViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import Foundation
import Supabase

@MainActor
class ChatViewModel: ObservableObject {
    private var subscriptionTask: Task<Void, Never>?
    
    @Published var chatMessages = [ChatMessage]()
    @Published var loadingState: LoadingState = .none
    
    func fetchChatMessages(for canvasId: UUID) async {
      //  await MainActor.run { self.loadingState = .loading }

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
            
            var messages: [ChatMessage] = []
            for item in result {
                if let idString = item["id"] as? String,
                   let id = UUID(uuidString: idString),
                   let userId = item["userId"] as? String,
                   let message = item["message"] as? String,
                   let timestampString = item["timestamp"] as? String,
                   let timestamp = ISO8601DateFormatter().date(from: timestampString) {
                    let chatMessage = ChatMessage(id: id, canvasId: canvasId.uuidString, userId: userId, message: message, timestamp: timestamp)
                    messages.append(chatMessage)
                }
            }
            
            await MainActor.run {
                    self.chatMessages = messages
            }
            
        } catch {
            print("Error fetching chat messages: \(error)")
        }
       // await MainActor.run { self.loadingState = .success }

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
    
    func subscribeToChatMessages(canvasId: String) {
        let channel = Supabase.client.channel("public:messages")

        let chatUpdates = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "messages",
            filter: "canvasId=eq.\(canvasId)"
        )

        Task {
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
                        
                        await MainActor.run {
                            self.chatMessages.append(newMessage)
                        }
                    }
                default:
                    break
                }
            }
        }
    }

}
