//
//  DrawingView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct DrawingView: UIViewRepresentable {
    @Binding var vm: CanvasView.ViewModel

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.bouncesZoom = true

        scrollView.addSubview(vm.canvas)
        vm.canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vm.canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vm.canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vm.canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vm.canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vm.canvas.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            vm.canvas.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        updateDrawingPolicy(for: vm.canvas)

    return scrollView
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
      updateDrawingPolicy(for: vm.canvas)
  }

  func makeCoordinator() -> Coordinator {
      Coordinator(canvas: $vm.canvas)
  }

  private func updateDrawingPolicy(for canvas: PKCanvasView) {
      canvas.drawingPolicy = vm.toolSelected ? .anyInput : .pencilOnly
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
