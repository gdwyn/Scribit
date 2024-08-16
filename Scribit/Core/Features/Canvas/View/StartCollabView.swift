//
//  StartCollabView.swift
//  Scribit
//
//  Created by Godwin IE on 15/08/2024.
//

import SwiftUI

struct StartCollabView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image(systemName: "person.line.dotted.person.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .padding(24)
                    .background(.accent.opacity(0.06), in: Circle())
                
                VStack(spacing: 8) {
                    Text("Share canvas id")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    
                    Text(canvasVM.currentCanvas.id.uuidString)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    
                    Button {
                        UIPasteboard.general.string = canvasVM.currentCanvas.id.uuidString
                        dismiss()
                    } label: {
                        Text("Copy")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.accent, in: .capsule)
                            .foregroundStyle(.white)
                            .padding(4)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StartCollabView()
}
