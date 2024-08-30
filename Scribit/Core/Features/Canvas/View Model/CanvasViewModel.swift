//
//  CanvasViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import Foundation
import PencilKit
import Supabase
import SwiftUI
import Realtime

class CanvasViewModel: ObservableObject {    
    @Published var currentCanvas = Canvas(id: UUID(), title: "", canvas: PKCanvasView(), date: Date.now, userId: "")
    @Published var toolPicker = PKToolPicker()
    @Published var toolSelected = false
    @Published var showclearCanvas = false
    @Published var isCollaborating = false
    @Published var showStartCollab = false
    
    @Published var shapes: [DraggableShape] = []
    @Published var texts: [DraggableText] = []
    @Published var showShapes = false
    @Published var activeUsers: [Presence] = []
    @Published var userColors: [Color] = [.blue, .green, .accentColor, .orange, .pink]
    
    @Published var selectedTextID: UUID? = nil
    @Published var editingText: String = ""
    
    private var undoManager: UndoManager?
    
    func subscribeToCanvas(canvasId: UUID) async {
        
        let channel = Supabase.client.channel("public:canvases")
        
        let changeStream = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "canvases",
            filter: "id=eq.\(canvasId.uuidString)"
        )
        
        await channel.subscribe()
        
        for await change in changeStream {
            switch change {
            case .insert(let action):
                if let updatedCanvasDataJSON = action.record["canvas"],
                   case let .string(updatedCanvasData) = updatedCanvasDataJSON {
                    await applyCanvasUpdate(from: updatedCanvasData)
                }
                
            case .update(let action):
                if let updatedCanvasDataJSON = action.record["canvas"],
                   case let .string(updatedCanvasData) = updatedCanvasDataJSON {
                    await applyCanvasUpdate(from: updatedCanvasData)
                }
                
            case .select(let action):
                if let updatedCanvasDataJSON = action.record["canvas"],
                   case let .string(updatedCanvasData) = updatedCanvasDataJSON {
                    await applyCanvasUpdate(from: updatedCanvasData)
                }
                
            default:
                break
            }
        }
    }

    private func applyCanvasUpdate(from base64String: String) async {
        guard let drawingData = Data(base64Encoded: base64String),
              let drawing = try? PKDrawing(data: drawingData) else {
            print("Failed to decode canvas data")
            return
        }

        let updatedDrawing = drawing
        
        DispatchQueue.main.async {
            self.currentCanvas.canvas.drawing = updatedDrawing
        }
    }

    func unsubscribe() async {
//        let channel = Supabase.client.channel("public:canvases")
//        await Supabase.client.removeChannel(channel)
        await Supabase.client.removeAllChannels()
    }

    func fetchCanvasById(canvasId: UUID) async {
        do {
            let query = try? await Supabase.client
                .from("canvases")
                .select()
                .eq("id", value: canvasId.uuidString)
                .execute()
            
            guard let data = query?.data,
                  let result = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                  let canvasData = result.first,
                  let title = canvasData["title"] as? String,
                  let base64DrawingData = canvasData["canvas"] as? String,
                  let dateString = canvasData["date"] as? String,
                  let date = ISO8601DateFormatter().date(from: dateString),
                  let drawingData = Data(base64Encoded: base64DrawingData),
                  let drawing = try? PKDrawing(data: drawingData)
            else {
                print("Failed to fetch or decode canvas")
                return
            }
            
            let canvasView = await PKCanvasView()
            
            let fetchedDrawing = drawing
            
            DispatchQueue.main.async {
                canvasView.drawing = fetchedDrawing
            }
            
            DispatchQueue.main.async {
                self.currentCanvas = Canvas(id: canvasId, title: title, canvas: canvasView, date: date, userId: "")
            }
        } catch {
            print("Error fetching canvas by ID: \(error)")
        }
    }
    
    func trackPresence(for canvasId: UUID, currentUser: String) async {
        let channel = Supabase.client.channel("canvas:\(canvasId.uuidString)")
        let presenceChange = channel.presenceChange()
        await channel.subscribe()

        Task {
            for await presence in presenceChange {
                do {
                    let joins = try presence.decodeJoins(as: Presence.self)
                    let leaves = try presence.decodeLeaves(as: Presence.self)
                    
                    DispatchQueue.main.async {
                        for join in joins {
                            if !self.activeUsers.contains(where: { $0.email == join.email }) {
                                self.activeUsers.append(join)
                            }
                        }
                        
                        for leave in leaves {
                            self.activeUsers.removeAll { $0.email == leave.email }
                        }
                    }
                } catch {
                    print("Error decoding presence: \(error)")
                }
            }
        }
        
        Task {
            try await channel.track(Presence(id: UUID(), email: currentUser))
        }
        
    }

    func stopTrackingPresence(for canvasId: UUID) async {
        let channel = Supabase.client.channel("canvas:\(canvasId.uuidString)")
        await channel.unsubscribe()
        DispatchQueue.main.async {
            self.activeUsers.removeAll()
        }
    }
    
    func saveDrawing() {
        let drawingImage = currentCanvas.canvas.drawing.image(from: currentCanvas.canvas.drawing.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(drawingImage, nil, nil, nil)
    }
    
    func showToolPicker() {
        print("Showing Tool Picker")
        toolPicker.setVisible(true, forFirstResponder: currentCanvas.canvas)
        toolPicker.addObserver(currentCanvas.canvas)
        currentCanvas.canvas.becomeFirstResponder()
        toolSelected = true
    }
    
    func hideToolPicker() {
        print("Hiding Tool Picker")
        toolPicker.setVisible(false, forFirstResponder: currentCanvas.canvas)
        toolPicker.removeObserver(currentCanvas.canvas)
        currentCanvas.canvas.resignFirstResponder()
        toolSelected = false
    }
    
//    MARK: REMOVED FEATURES FOR MVP ⬇️
//    func setUndoManager(_ undoManager: UndoManager?) {
//        self.undoManager = undoManager
//    }
//    
//    func addShape(type: ShapeType, at position: CGPoint) {
//        let shape = DraggableShape(position: position, type: type)
//        shapes.append(shape)
//        registerUndo(actionName: "Add Shape") {
//            self.removeShape(id: shape.id)
//        }
//    }
//    
//    func removeShape(id: UUID) {
//        if let index = shapes.firstIndex(where: { $0.id == id }) {
//            let shape = shapes[index]
//            shapes.remove(at: index)
//            registerUndo(actionName: "Remove Shape") {
//                self.shapes.insert(shape, at: index)
//            }
//        }
//    }
//    
//    func addText(at position: CGPoint) {
//        let newText = DraggableText(position: position, text: "Tap to edit")
//        texts.append(newText)
//        selectedTextID = newText.id
//        editingText = newText.text
//        registerUndo(actionName: "Add Text") {
//            self.removeText(id: newText.id)
//        }
//    }
//    
//    func removeText(id: UUID) {
//        if let index = texts.firstIndex(where: { $0.id == id }) {
//            let text = texts[index]
//            texts.remove(at: index)
//            registerUndo(actionName: "Remove Text") {
//                self.texts.insert(text, at: index)
//            }
//        }
//    }
//    
//    func selectText(at position: CGPoint) {
//        if let selectedText = texts.first(where: { distance(from: $0.position, to: position) < 50 }) {
//            selectedTextID = selectedText.id
//            editingText = selectedText.text
//        } else {
//            selectedTextID = nil
//        }
//    }
//    
//    func updateSelectedText(with newText: String) {
//        if let index = texts.firstIndex(where: { $0.id == selectedTextID }) {
//            let oldText = texts[index].text
//            texts[index].text = newText
//            registerUndo(actionName: "Edit Text") {
//                self.texts[index].text = oldText
//            }
//        }
//    }
//    
//    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
//        sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
//    }
//    
//    private func registerUndo(actionName: String, action: @escaping () -> Void) {
//        undoManager?.registerUndo(withTarget: self, handler: { _ in
//            action()
//        })
//        undoManager?.setActionName(actionName)
//    }
//    
//    func updateShapePosition(id: UUID, to position: CGPoint) {
//        if let index = shapes.firstIndex(where: { $0.id == id }) {
//            shapes[index].position = position
//        }
//    }
//    
//    func updateTextPosition(id: UUID, to position: CGPoint) {
//        if let index = texts.firstIndex(where: { $0.id == id }) {
//            texts[index].position = position
//        }
//    }
    
}
