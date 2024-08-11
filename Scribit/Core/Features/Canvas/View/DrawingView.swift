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

        scrollView.addSubview(canvasVM.canvas)
        canvasVM.canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasVM.canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvasVM.canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvasVM.canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvasVM.canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            canvasVM.canvas.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            canvasVM.canvas.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        updateDrawingPolicy(for: canvasVM.canvas)

    return scrollView
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
      updateDrawingPolicy(for: canvasVM.canvas)
  }

  func makeCoordinator() -> Coordinator {
      Coordinator(canvas: $canvasVM.canvas)
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
