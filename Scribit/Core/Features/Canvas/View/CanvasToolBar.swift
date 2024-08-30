//
//  CanvasToolBar.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI

struct CanvasToolBar: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var canvasVM: CanvasViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    
    var body: some View {
        HStack {
            if !canvasVM.isCollaborating && !canvasVM.toolSelected {
                Button {
                    dismiss()
                    Task {
                        await homeVM.fetchCanvases()
                    }
                    chatVM.subscribedToChats = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(12)
                        .background(.white, in: Circle())
                }
                .frame(width: 120, alignment: .leading)
            } else if !canvasVM.toolSelected {
                    Button {
                        Task {
                            await canvasVM.unsubscribe()
                        }
                        canvasVM.isCollaborating = false
                    } label: {
                        HStack {
                            Image(systemName: "person.line.dotted.person.fill")
                            Text("End")
                        }
                        .font(.callout)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.red, in: .capsule)
                        .foregroundStyle(.white)
                        .frame(width: 120, alignment: .leading)
                        
                    }
                    .transition(.scale)
            } else {
                Color.clear
                    .frame(width: 120, height: 0, alignment: .leading)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button {
                    undoManager?.undo()
                    Task {
                        await homeVM.updateCanvas(canvas: canvasVM.currentCanvas)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                
                Button {
                    undoManager?.redo()
                    Task {
                        await homeVM.updateCanvas(canvas: canvasVM.currentCanvas)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.forward")
                }
                
            }
            .padding()
            .background(.gray.opacity(0.06), in: .capsule)
            .foregroundStyle(.gray)
            
            Spacer()
            
            if canvasVM.toolSelected {
                Button {
                    withAnimation {
                        canvasVM.hideToolPicker()
                    }
                    Task {
                        await homeVM.updateCanvas(canvas: canvasVM.currentCanvas)
                    }
                } label: {
                    Text("Done")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.accent, in: .capsule)
                        .foregroundStyle(.white)
                    
                }
                .transition(.scale)
                .frame(width: 120, alignment: .trailing)
                
            } else {
                HStack(spacing: 0) {
                    Button {
                        canvasVM.showStartCollab = true
                    } label: {
                        Image(systemName: "person.line.dotted.person.fill")
                            .font(.callout)
                            .padding(12)
                            .background(.white, in: .circle)
                            .foregroundStyle(.gray)
                    }
                    
                    Button {
                        canvasVM.saveDrawing()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                            .padding(12)
                            .background(.white, in: .capsule)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(width: 120, alignment: .trailing)
                .transition(.scale)
                
            }
            
        }
        .sheet(isPresented: $canvasVM.showStartCollab) {
            StartCollabView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

