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
        
        func saveDrawing() {
            let drawingImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1.0)
            UIImageWriteToSavedPhotosAlbum(drawingImage, nil, nil, nil)
        }
        
    }
}
