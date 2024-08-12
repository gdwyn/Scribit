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
                        Image(systemName: "square.and.arrow.down.on.square")
                            .font(.headline)
                            .fontWeight(.medium)

                    }
                    
//                    Button {
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.headline)
//                            .fontWeight(.medium)
//
//                    }
                    
                }
                .transition(.scale)
                .frame(width: 120, alignment: .trailing)
                
                
            }
            
        }
    }
}

