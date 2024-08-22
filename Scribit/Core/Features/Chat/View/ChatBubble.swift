//
//  ChatBubble.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import SwiftUI

struct ChatBubble: View {
    var appUser: AppUser?
    let message: ChatMessage
    
    @EnvironmentObject var chatVM : ChatViewModel
    
    var body: some View {
        VStack(alignment: appUser?.email == message.userId ? .trailing : .leading) {
            Text(message.userId)
                .font(.footnote)
                .foregroundStyle(.gray)
            
            Text(message.message)
                .multilineTextAlignment(appUser?.email == message.userId ? .trailing : .leading)
                .padding()
                .background(
                    appUser?.email == message.userId ? .accent : .gray.opacity(0.06), in: RoundedRectangle(cornerRadius: 16)
                )
                .foregroundStyle(appUser?.email == message.userId ? .white : .dark)
            
//            switch chatVM.loadingState {
//            case .none:
//                EmptyView()
//            case .loading:
//                ProgressView()
//                    .padding()
//            case .success:
//                Text(message.message)
//                    .multilineTextAlignment(appUser?.email == message.userId ? .trailing : .leading)
//                    .padding()
//                    .background(
//                        appUser?.email == message.userId ? .accent : .gray.opacity(0.06), in: RoundedRectangle(cornerRadius: 16)
//                    )
//                    .foregroundStyle(appUser?.email == message.userId ? .white : .dark)
//            case .error(let string):
//                Text(string)
//            }
            

            Text(message.timestamp, format: .dateTime.hour().minute())
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: appUser?.email == message.userId ? .trailing : .leading)

    }

}
