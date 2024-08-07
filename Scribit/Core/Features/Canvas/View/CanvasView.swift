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
                                .position(text.position)
                                .onTapGesture {
                                    vm.selectText(at: text.position)
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
                                TextField("Edit Text", text: $vm.editingText, onCommit: {
                                    vm.updateSelectedText(with: vm.editingText)
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200, height: 40)
                                .position(selectedText.position)
                            }
                        }
                    )
                
                VStack {
                    CanvasToolBar(vm: vm)
                    
                    Spacer()
                    
                    ToolPickerView(vm: vm)
                    
                    
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            vm.setUndoManager(undoManager)
        }
    }
}


struct ShapeView: View {
    let shape: DraggableShape

    var body: some View {
        switch shape.type {
        case .rectangle:
            Rectangle().frame(width: 50, height: 50)
        case .circle:
            Circle().frame(width: 50, height: 50)
        case .triangle:
            Triangle().frame(width: 50, height: 50)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CanvasView()
}
