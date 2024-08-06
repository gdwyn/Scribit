//
//  CanvasView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct CanvasView: View {
    @State private var canvas = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var toolSelected = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                DottedBackgroundView(dotColor: .accent.opacity(0.2), dotSize: 2, spacing: 8, canvas: $canvas, toolSelected: $toolSelected, toolPicker: $toolPicker)
                    .navigationBarTitleDisplayMode(.inline)
                
                VStack {
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
                        
                        if toolSelected {
                            Button {
                                withAnimation {
                                    toolPicker.setVisible(false, forFirstResponder: canvas)
                                    toolPicker.removeObserver(canvas)
                                    canvas.resignFirstResponder()
                                    toolSelected = false
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
                                    saveDrawing()
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
                    
                    Spacer()
                    
                    
                    if !toolSelected {
                        HStack(spacing: 24) {
                            Button {
                                withAnimation {
                                    toolPicker.setVisible(true, forFirstResponder: canvas)
                                    toolPicker.addObserver(canvas)
                                    canvas.becomeFirstResponder()
                                    toolSelected = true
                                }
                            } label: {
                                Image(systemName: "paintbrush.pointed")
                                    .font(.title3)
                                    .fontWeight(.medium)

                            }
                            
                            Button {
                            
                            } label: {
                                Image(systemName: "triangle")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            
                            Button {
                            } label: {
                                Image(systemName: "character.textbox")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(alignment: .bottom)
                        .padding(14)
                        .background(
                            Capsule()
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                        )
                        .shadow(color: Color.gray.opacity(0.06), radius: 4, x: 0, y: 4))
                        .transition(.scale)

                    }
                    
                }
                .padding(.horizontal)

            }
        }
        
        
    }
    func saveDrawing() {
        let drawingImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(drawingImage, nil, nil, nil)
    }
}

#Preview {
    CanvasView()
}
