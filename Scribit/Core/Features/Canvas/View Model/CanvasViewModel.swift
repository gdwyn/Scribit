//
//  CanvasViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import Foundation
import PencilKit

extension CanvasView {
    @Observable
    class ViewModel {
        var canvas = PKCanvasView()
        var toolPicker = PKToolPicker()
        var toolSelected = false
        
        var shapes: [DraggableShape] = []
        var texts: [DraggableText] = []
        
        var selectedTextID: UUID? = nil
        var editingText: String = ""
        
        private var undoManager: UndoManager?
        
        func saveDrawing() {
            let drawingImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1.0)
            UIImageWriteToSavedPhotosAlbum(drawingImage, nil, nil, nil)
        }
        
        func setUndoManager(_ undoManager: UndoManager?) {
            self.undoManager = undoManager
        }
        
        func addShape(type: ShapeType, at position: CGPoint) {
            let shape = DraggableShape(position: position, type: type)
            shapes.append(shape)
            registerUndo(actionName: "Add Shape") {
                self.removeShape(id: shape.id)
            }
        }
        
        func removeShape(id: UUID) {
            if let index = shapes.firstIndex(where: { $0.id == id }) {
                let shape = shapes[index]
                shapes.remove(at: index)
                registerUndo(actionName: "Remove Shape") {
                    self.shapes.insert(shape, at: index)
                }
            }
        }
        
        func addText(at position: CGPoint) {
            let newText = DraggableText(position: position, text: "Tap to edit")
            texts.append(newText)
            selectedTextID = newText.id
            editingText = newText.text
            registerUndo(actionName: "Add Text") {
                self.removeText(id: newText.id)
            }
        }
        
        func removeText(id: UUID) {
            if let index = texts.firstIndex(where: { $0.id == id }) {
                let text = texts[index]
                texts.remove(at: index)
                registerUndo(actionName: "Remove Text") {
                    self.texts.insert(text, at: index)
                }
            }
        }
        
        func selectText(at position: CGPoint) {
            if let selectedText = texts.first(where: { distance(from: $0.position, to: position) < 50 }) {
                selectedTextID = selectedText.id
                editingText = selectedText.text
            } else {
                selectedTextID = nil
            }
        }
        
        func updateSelectedText(with newText: String) {
            if let index = texts.firstIndex(where: { $0.id == selectedTextID }) {
                let oldText = texts[index].text
                texts[index].text = newText
                registerUndo(actionName: "Edit Text") {
                    self.texts[index].text = oldText
                }
            }
        }
        
        private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
            sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
        }
        
        private func registerUndo(actionName: String, action: @escaping () -> Void) {
            undoManager?.registerUndo(withTarget: self, handler: { _ in
                action()
            })
            undoManager?.setActionName(actionName)
        }
        
        func updateShapePosition(id: UUID, to position: CGPoint) {
            if let index = shapes.firstIndex(where: { $0.id == id }) {
                shapes[index].position = position
            }
        }

        func updateTextPosition(id: UUID, to position: CGPoint) {
            if let index = texts.firstIndex(where: { $0.id == id }) {
                texts[index].position = position
            }
        }
        
        func showToolPicker() {
            print("Showing Tool Picker")
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            toolSelected = true
        }

        func hideToolPicker() {
            print("Hiding Tool Picker")
            toolPicker.setVisible(false, forFirstResponder: canvas)
            toolPicker.removeObserver(canvas)
            canvas.resignFirstResponder()
            toolSelected = false
        }

    }
}
