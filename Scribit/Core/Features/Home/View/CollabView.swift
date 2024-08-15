//
//  JoinCollabView.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI

struct CollabView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    
    @State private var canvasId = ""
    
    var body: some View {
        NavigationStack {
            
            if canvasVM.isCollaborating {
                CanvasView()
                    .transition(.scale)
                    .onAppear {
                        canvasVM.subscribeToCanvasChanges(canvasId: canvasVM.currentCanvas.id)
                    }
                    .onDisappear {
                        canvasVM.unsubscribe()
                    }
            } else {
                VStack {
                    Image(systemName: "person.line.dotted.person.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                        .padding(24)
                        .background(.accent.opacity(0.06), in: Circle())
                    
                    Text("Join collaboration")
                    
                    VStack(spacing: 14) {
                        HStack(spacing: 16) {
                            TextField("Enter canvas Id", text: $canvasId)
                                .font(.title.bold())
                                .foregroundStyle(.dark)
                                .multilineTextAlignment(.center)
                            
                            if !canvasId.isEmpty {
                                Button {
                                    canvasId = ""
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        
                            Button {
                                if let canvasId = UUID(uuidString: canvasId) {
                                    Task {
                                        await canvasVM.joinCollaboration(with: canvasId)
                                        withAnimation {
                                            canvasVM.isCollaborating = true
                                        }
                                    }
                                }
                            } label: {
                                Text("Join")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.accent, in: .capsule)
                                    .foregroundStyle(.white)
                                    .opacity(!canvasId.isValidUUID() ? 0.5 : 1)
                                
                            }
                            .disabled(!canvasId.isValidUUID())
                        
                    }
                    .padding(.top, 14)
                    .padding(.horizontal)
                                    
                    Spacer()
                }
            }
            
        }
    }
}

#Preview {
    CollabView()
}
