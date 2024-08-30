//
//  HomeViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 11/08/2024.
//

import Foundation
import SwiftUI
import PencilKit

class HomeViewModel: ObservableObject {
    @Published var columns = [GridItem(.adaptive(minimum: 160), spacing: 18)]
    
    @Published var canvasList: [Canvas] = []
    @Published var loadingState: LoadingState = .none

    @Published var isNavigatingToCanvasView = false
    @Published var showCreateNew = false
    @Published var showProfile = false

    // create
    func createCanvas(title: String) async {
        do {
            let currentUser = try await Supabase.shared.getCurrentSession()
            let newCanvasView = await PKCanvasView()
            let drawingData = await newCanvasView.drawing.dataRepresentation()
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
                withAnimation{
                    self.canvasList.append(newCanvas)
                }
            }
        } catch {
            print("Error creating canvas: \(error)")
        }
    }
    
    
    // fetch
    func fetchCanvases() async {
        await MainActor.run { self.loadingState = .loading }
        
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
                        let canvasView = await PKCanvasView()
                        
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
            
            await MainActor.run { self.loadingState = .success }
            
        } catch {
            await MainActor.run { self.loadingState = .error(error.localizedDescription) }
        }
    }
    
    // update
    func updateCanvas(canvas: Canvas) async {
        do {
            // convert the drawing to base64
            let drawingData = await canvas.canvas.drawing.dataRepresentation()
            let base64DrawingData = drawingData.base64EncodedString()
            
            // cpdate the canvas in Supabase
            try await Supabase.client
                .from("canvases")
                .update([
                    "title": canvas.title,
                    "canvas": base64DrawingData,
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
                
                await MainActor.run {
                    withAnimation {
                        self.canvasList.removeAll { $0.id == canvas.id }
                    }
                }
                
                //await fetchCanvases()
                
            } catch {
                print("Error deleting canvas: \(error)")
            }
        }
    }
}
