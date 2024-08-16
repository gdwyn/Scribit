//
//  CanvasView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @State private var currentLocation: CGPoint = .init(x: 40, y: 80)
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                DottedBackgroundView(dotColor: Color.accent.opacity(0.2))
                    .gesture(
                        canvasVM.toolSelected ? nil : DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                currentLocation = value.location
                            }
                            .onEnded { value in
                                canvasVM.selectText(at: value.location)
                            }
                    )
                
                    .overlay(
                        ForEach(canvasVM.shapes) { shape in
                            ShapeView(shape: shape)
                                .position(shape.position)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            canvasVM.updateShapePosition(id: shape.id, to: value.location)
                                        }
                                )
                        }
                    )
                    .overlay(
                        ForEach(canvasVM.texts) { text in
                            Text(text.text)
                                .font(.headline)
                                .padding()
                                .position(text.position)
                                .onTapGesture {
                                    canvasVM.selectText(at: text.position)
                                }
                                .onLongPressGesture {
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            canvasVM.updateTextPosition(id: text.id, to: value.location)
                                        }
                                )
                        }
                    )
                    .overlay(
                        Group {
                            if let selectedTextID = canvasVM.selectedTextID,
                               let selectedText = canvasVM.texts.first(where: { $0.id == selectedTextID }) {
                                TextField("Edit Text", text: $canvasVM.editingText)
                                .onChange(of: canvasVM.editingText) {
                                    canvasVM.updateSelectedText(with: canvasVM.editingText)
                                }
                                                          
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200, height: 40)
                                .position(selectedText.position)
                            }
                        }
                    )
                
                VStack {
                    CanvasToolBar()
                    
                    Spacer()
                    
                    if canvasVM.showShapes {
                        ShapeSelectView()
                    } else {
                        ToolPickerView()
                    }
        
                }
                .padding(.horizontal)
                .alert("Clear canvas", isPresented: $canvasVM.showclearCanvas) {
                    Button("Cancel", role: .cancel) { }
                    Button("Clear", role: .destructive) {
                        canvasVM.currentCanvas.canvas.drawing = PKDrawing()
                    }
                } message: {
                    Text("Everything on this canvas will be cleared")
                }
                
            }
            .navigationBarBackButtonHidden()
        }
        .onAppear {
            canvasVM.setUndoManager(undoManager)
            canvasVM.subscribeToCanvasChanges(canvasId: canvasVM.currentCanvas.id)
        }
        .onDisappear {
            canvasVM.unsubscribe()
        }
       
    }
}

#Preview {
    CanvasView()
}
