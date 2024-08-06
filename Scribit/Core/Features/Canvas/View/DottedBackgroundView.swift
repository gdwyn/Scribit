//
//  DottedBackgroundView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI
import PencilKit

struct DottedBackgroundView: View {
    let dotColor: Color
    let dotSize: CGFloat
    let spacing: CGFloat
    
    @Binding var canvas: PKCanvasView
    @Binding var toolSelected: Bool
    @Binding var toolPicker: PKToolPicker

    var body: some View {
        ZStack {
            DrawingView(canvas: $canvas, toolSelected: $toolSelected, toolPicker: $toolPicker)
            
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    for x in stride(from: 0, to: width, by: dotSize + spacing) {
                        for y in stride(from: 0, to: height, by: dotSize + spacing) {
                            path.addEllipse(in: CGRect(x: x, y: y, width: dotSize, height: dotSize))
                        }
                    }
                }
                .fill(dotColor)
            }
            .clipped()
            .edgesIgnoringSafeArea(.all) 
            
        }
    }
}
