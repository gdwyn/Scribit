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

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.bouncesZoom = true

        scrollView.addSubview(canvasVM.currentCanvas.canvas)
        canvasVM.currentCanvas.canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasVM.currentCanvas.canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvasVM.currentCanvas.canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvasVM.currentCanvas.canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvasVM.currentCanvas.canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            canvasVM.currentCanvas.canvas.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            canvasVM.currentCanvas.canvas.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        updateDrawingPolicy(for: canvasVM.currentCanvas.canvas)

    return scrollView
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
      updateDrawingPolicy(for: canvasVM.currentCanvas.canvas)
  }

  func makeCoordinator() -> Coordinator {
      Coordinator(canvas: $canvasVM.currentCanvas.canvas)
  }

  private func updateDrawingPolicy(for canvas: PKCanvasView) {
      canvas.drawingPolicy = canvasVM.toolSelected ? .anyInput : .pencilOnly
  }

  class Coordinator: NSObject, UIScrollViewDelegate {
    @Binding var canvas: PKCanvasView

    init(canvas: Binding<PKCanvasView>) {
      _canvas = canvas
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return canvas
    }
  }
}
