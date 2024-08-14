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
                HStack(spacing: 18) {
                    TextField("Enter canvas Id", text: $canvasId)
                            .font(.title.bold())
                            .foregroundStyle(.dark)

                    if !canvasId.isEmpty {
                        Button {
                            canvasId = ""
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
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
                                .opacity(canvasId.isEmpty ? 0.5 : 1)

                        }
                        .disabled(canvasId.isEmpty)
                        
                    }
                    .padding(.top, 14)
                    .padding(.horizontal)
                    .navigationTitle("Join collaboration")
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                    Spacer()
                    
                }
                
            }
        }
    }

#Preview {
    CollabView()
}
