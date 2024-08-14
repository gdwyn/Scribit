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

@MainActor
class CanvasViewModel: ObservableObject {
    private var subscriptionTask: Task<Void, Never>?
    
    @Published var currentCanvas = Canvas(id: UUID(), title: "", canvas: PKCanvasView(), date: Date.now, userId: "")
    @Published var canvasList: [Canvas] = []
    @Published var toolPicker = PKToolPicker()
    @Published var toolSelected = false
    @Published var showclearCanvas = false
    @Published var isCollaborating = false
    
    @Published var shapes: [DraggableShape] = []
    @Published var texts: [DraggableText] = []
    @Published var showShapes = false
    
    @Published var selectedTextID: UUID? = nil
    @Published var editingText: String = ""
    
    private var undoManager: UndoManager?
    
    // create
    func createCanvas(title: String) async {
        do {
            let currentUser = try await Supabase.shared.getCurrentSession()
            let newCanvasView = PKCanvasView()
            let drawingData = newCanvasView.drawing.dataRepresentation()
            let base64DrawingData = drawingData.base64EncodedString()
            
            let newCanvas = Canvas(id: UUID(), title: title, canvas: newCanvasView, date: Date.now, userId: currentUser.uid)
            
            try await Supabase.client
                .from("canvases")
                .insert(["id": newCanvas.id.uuidString,
                         "title": newCanvas.title,
                         "canvas": base64DrawingData,
                         "date": ISO8601DateFormatter().string(from: newCanvas.date),
                         "userId": newCanvas.userId
                        ])
                .execute()
            
            DispatchQueue.main.async {
                self.canvasList.append(newCanvas)
            }
        } catch {
            print("Error creating canvas: \(error)")
        }
    }
    
    
    // fetch
    func fetchCanvases() async {
        do {
            let currentUser = try await Supabase.shared.getCurrentSession()
            
            let query = try? await Supabase.client
                .from("canvases")
                .select()
                .eq("userId", value: currentUser.uid)
                .execute()
            
            // decode the JSON data into an array of dictionaries
            guard let data = query?.data,
                  let result = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                print("No data fetched or data format is incorrect")
                return
            }
            
            var fetchedCanvases: [Canvas] = []
            for item in result {
                if let idString = item["id"] as? String,
                   let id = UUID(uuidString: idString),
                   let title = item["title"] as? String,
                   let base64DrawingData = item["canvas"] as? String,
                   let dateString = item["date"] as? String,
                   let date = ISO8601DateFormatter().date(from: dateString) {
                    
                    if let drawingData = Data(base64Encoded: base64DrawingData),
                       let drawing = try? PKDrawing(data: drawingData) {
                        let canvasView = PKCanvasView()
                        
                        await MainActor.run {
                            canvasView.drawing = drawing // main thread
                        }
                        
                        let canvas = Canvas(id: id, title: title, canvas: canvasView, date: date, userId: currentUser.uid)
                        fetchedCanvases.append(canvas)
                    }
                }
            }
            
            let canvasesToSet = fetchedCanvases
            await MainActor.run {
                self.canvasList = canvasesToSet // main thread
            }
        } catch {
            print("Error fetching canvases: \(error)")
        }
    }
    
    // update
    func updateCanvas(canvas: Canvas) async {
        do {
            // convert the drawing to base64
            let drawingData = canvas.canvas.drawing.dataRepresentation()
            let base64DrawingData = drawingData.base64EncodedString()
            
            // cpdate the canvas in Supabase
            try await Supabase.client
                .from("canvases")
                .update([
                    "title": canvas.title,
                    "canvas": base64DrawingData,
                   // "date": ISO8601DateFormatter().string(from: canvas.date)
                ])
                .eq("id", value: canvas.id.uuidString)
                .execute()
            
            print("Canvas updated successfully")
            
            // update the local canvas list with the modified canvas
            if let index = canvasList.firstIndex(where: { $0.id == canvas.id }) {
                await MainActor.run {
                    self.canvasList[index] = canvas
                }
            }
            
        } catch {
            print("Error updating canvas: \(error)")
        }
    }
    
    // delete
    func deleteCanvas(canvas: Canvas) {
        Task {
            do {
                try await Supabase.client
                    .from("canvases")
                    .delete()
                    .eq("id", value: canvas.id.uuidString)
                    .execute()

                // After successful deletion, remove the canvas from the list
                await MainActor.run {
                    withAnimation {
                        self.canvasList.removeAll { $0.id == canvas.id }
                    }
                }

            } catch {
                print("Error deleting canvas: \(error)")
            }
        }
    }
    
    // subscribe to realtime
    func subscribeToCanvasChanges(canvasId: UUID) {
        // cancel any previous subscription
        subscriptionTask?.cancel()

        subscriptionTask = Task {
            let channel = Supabase.client.channel("public:canvases")

            // subscribe to updates on the specific canvas ID
            let updatesStream = channel.postgresChange(
                AnyAction.self,
                schema: "public",
                table: "canvases",
                filter: "id=eq.\(canvasId.uuidString)"
            )

            await channel.subscribe()

            for await change in updatesStream {
                switch change {
                case .update(let action):
                    if let updatedCanvasDataJSON = action.record["canvas"],
                       case let .string(updatedCanvasData) = updatedCanvasDataJSON {
                        await applyCanvasUpdate(from: updatedCanvasData)
                    }
                default:
                    break
                }
            }
        }
    }

    private func applyCanvasUpdate(from base64String: String) async {
        guard let drawingData = Data(base64Encoded: base64String),
              let drawing = try? PKDrawing(data: drawingData) else {
            print("Failed to decode canvas data")
            return
        }

        await MainActor.run {
            currentCanvas.canvas.drawing = drawing
        }
    }


    func unsubscribe() {
        subscriptionTask?.cancel()
        subscriptionTask = nil
    }

    func joinCollaboration(with canvasId: UUID) async {
        await fetchCanvasById(canvasId: canvasId)
        subscribeToCanvasChanges(canvasId: canvasId)
    }
        
    private func fetchCanvasById(canvasId: UUID) async {
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
            
            let canvasView = PKCanvasView()
            canvasView.drawing = drawing
            
            await MainActor.run {
                self.currentCanvas = Canvas(id: canvasId, title: title, canvas: canvasView, date: date, userId: "")
            }
        } catch {
            print("Error fetching canvas by ID: \(error)")
        }
    }
    
    
    
    func saveDrawing() {
        let drawingImage = currentCanvas.canvas.drawing.image(from: currentCanvas.canvas.drawing.bounds, scale: 1.0)
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
}
