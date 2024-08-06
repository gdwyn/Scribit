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
    
    @Binding var vm: CanvasView.ViewModel

    var body: some View {
        ZStack {
            DrawingView(vm: $vm)
            
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    for x in stride(from: 0, to: width, by: 2 + 8) {
                        for y in stride(from: 0, to: height, by: 2 + 8) {
                            path.addEllipse(in: CGRect(x: x, y: y, width: 2, height: 2))
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
