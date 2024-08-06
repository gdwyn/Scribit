//
//  DrawingView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct DrawingView: UIViewRepresentable {
  @Binding var canvas: PKCanvasView
  @Binding var toolSelected: Bool
  @Binding var toolPicker: PKToolPicker

  func makeUIView(context: Context) -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0
    scrollView.bouncesZoom = true

    scrollView.addSubview(canvas)
    canvas.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
      canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      canvas.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      canvas.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])

    updateDrawingPolicy(for: canvas)

    return scrollView
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
    updateDrawingPolicy(for: canvas)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(canvas: $canvas)
  }

  private func updateDrawingPolicy(for canvas: PKCanvasView) {
    canvas.drawingPolicy = toolSelected ? .anyInput : .pencilOnly
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
