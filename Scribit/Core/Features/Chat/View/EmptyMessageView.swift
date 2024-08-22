//
//  EmptyMessageView.swift
//  Scribit
//
//  Created by Godwin IE on 22/08/2024.
//

import SwiftUI

struct EmptyMessageView: View {

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "ellipsis.bubble.fill")
                .font(.largeTitle)
                .foregroundStyle(.accent)
                .padding(24)
                .background(.accent.opacity(0.06), in: Circle())
            
            VStack(spacing: 6) {
                Text("No messages")
                    .font(.title3)
                Text("Conversatioins had in this canvas will be shown here")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .frame(width: 260)
                    .multilineTextAlignment(.center)
            }
            
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    EmptyMessageView()
}
