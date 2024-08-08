//
//  CanvasView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct CanvasView: View {
    @State private var vm = ViewModel()
    @State private var currentLocation: CGPoint = .init(x: 40, y: 80)
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                DottedBackgroundView(dotColor: .accent.opacity(0.2), vm: $vm)
                    .gesture(
                        vm.toolSelected ? nil : DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                currentLocation = value.location
                            }
                            .onEnded { value in
                                vm.selectText(at: value.location)
                            }
                    )
                
                    .overlay(
                        ForEach(vm.shapes) { shape in
                            ShapeView(shape: shape)
                                .position(shape.position)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            vm.updateShapePosition(id: shape.id, to: value.location)
                                        }
                                )
                        }
                    )
                    .overlay(
                        ForEach(vm.texts) { text in
                            Text(text.text)
                                .font(.headline)
                                .padding()
                                .position(text.position)
                                .onTapGesture {
                                    vm.selectText(at: text.position)
                                }
                                .onLongPressGesture {
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            vm.updateTextPosition(id: text.id, to: value.location)
                                        }
                                )
                        }
                    )
                    .overlay(
                        Group {
                            if let selectedTextID = vm.selectedTextID,
                               let selectedText = vm.texts.first(where: { $0.id == selectedTextID }) {
                                TextField("Edit Text", text: $vm.editingText)
                                .onChange(of: vm.editingText) {
                                    vm.updateSelectedText(with: vm.editingText)
                                }
                                                          
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200, height: 40)
                                .position(selectedText.position)
                            }
                        }
                    )
                
                VStack {
                    CanvasToolBar(vm: vm)
                    
                    Spacer()
                    
                    if vm.showShapes {
                        ShapeSelectView(vm: vm)
                    } else {
                        ToolPickerView(vm: vm)
                    }
        
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            vm.setUndoManager(undoManager)
        }
    }
}

#Preview {
    CanvasView()
}
