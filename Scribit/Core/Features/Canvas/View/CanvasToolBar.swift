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
    
    var body: some View {
        HStack {
            if !canvasVM.isCollaborating {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(8)
                        .background(.gray.opacity(0.06), in: Circle())
                    
                }
                .frame(width: 120, alignment: .leading)
            } else {
                Button {
                    canvasVM.unsubscribe()
                    canvasVM.isCollaborating = false
                } label: {
                    HStack {
                        Image(systemName: "dot.radiowaves.left.and.right")
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
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button {
                    undoManager?.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                
                Button {
                    undoManager?.redo()
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
                        await canvasVM.updateCanvas(canvas: canvasVM.currentCanvas)
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
                HStack(spacing: 14) {
                    Button {
                        canvasVM.saveDrawing()
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Export")
                        }
                        .font(.callout)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white, in: .capsule)
                        .foregroundStyle(.gray)
                        .frame(width: 120, alignment: .trailing)

                    }
                    
                }
                .transition(.scale)
                
            }
            
        }
    }
}

