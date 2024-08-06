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
    
    var vm: CanvasView.ViewModel
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .fontWeight(.medium)

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
            
            if vm.toolSelected {
                Button {
                    withAnimation {
                        vm.toolPicker.setVisible(false, forFirstResponder: vm.canvas)
                        vm.toolPicker.removeObserver(vm.canvas)
                        vm.canvas.resignFirstResponder()
                        vm.toolSelected = false
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
                        vm.saveDrawing()
                    } label: {
                        Image(systemName: "square.and.arrow.down.on.square")
                            .font(.headline)
                            .fontWeight(.medium)

                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline)
                            .fontWeight(.medium)

                    }
                    
                }
                .transition(.scale)
                .frame(width: 120, alignment: .trailing)
                
                
            }
            
        }
    }
}

