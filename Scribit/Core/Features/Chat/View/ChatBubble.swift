//
//  ChatBubble.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    
    @EnvironmentObject var chatVM : ChatViewModel
    @EnvironmentObject var authVM : AuthViewModel
    
    var body: some View {
        VStack(alignment: authVM.appUser?.email == message.userId ? .trailing : .leading) {
            Text(message.userId)
                .font(.footnote)
                .foregroundStyle(.gray)
            
            Text(message.message)
                .multilineTextAlignment(authVM.appUser?.email == message.userId ? .trailing : .leading)
                .padding()
                .background(
                    authVM.appUser?.email == message.userId ? .accent : .gray.opacity(0.06), in: RoundedRectangle(cornerRadius: 16)
                )
                .foregroundStyle(authVM.appUser?.email == message.userId ? .white : .dark)

            Text(message.timestamp, format: .dateTime.hour().minute())
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: authVM.appUser?.email == message.userId ? .trailing : .leading)

    }

}
