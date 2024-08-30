//
//  DrawingView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct DrawingView: UIViewRepresentable {
    @EnvironmentObject var canvasVM: CanvasViewModel
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvas: PKCanvasView
        
        init(canvas: PKCanvasView) {
            self.canvas = canvas
            super.init()
            canvas.delegate = self
        }
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = canvasVM.currentCanvas.canvas
        
        canvasView.drawingPolicy = .pencilOnly
        canvasView.contentSize = CGSize(width: 2000, height: 4000)
        canvasView.drawingPolicy = .anyInput
        canvasView.minimumZoomScale = 0.2
        canvasView.maximumZoomScale = 4.0
        canvasView.backgroundColor = .clear
        canvasView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let initialOffset = CGPoint(x: (canvasView.contentSize.width - canvasView.bounds.width) / 2.5,
                                    y: (canvasView.contentSize.height - canvasView.bounds.height) / 2.5)
        canvasView.contentOffset = initialOffset
                
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawingPolicy = canvasVM.toolSelected ? .anyInput : .pencilOnly
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: canvasVM.currentCanvas.canvas)
    }
}
