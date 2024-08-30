//
//  CanvasCard.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI
import PencilKit

struct CanvasCard: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var canvasVM: CanvasViewModel
    
    var canvas: Canvas
    
    var body: some View {
        Button {
            canvasVM.currentCanvas = canvas
            homeVM.isNavigatingToCanvasView = true
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                Image("canvasthumbnail")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 128)
                    .padding(26)
                    .background(.accent.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(canvas.title)
                            .font(.headline)
                            .foregroundStyle(.dark)
                        
                        Text(canvas.date, format: .relative(presentation: .numeric, unitsStyle: .abbreviated))
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        homeVM.deleteCanvas(canvas: canvas)
                    } label: {
                        Image(systemName: "xmark.bin.fill")
                            .padding(8)
                            .foregroundStyle(.gray)
                            .background(.gray.opacity(0.06), in: Circle())
                    }
                }
            }
            
        }
        .padding(.top, 28)
        .transition(.scale)
        .transition(.opacity)
        
    }
}

#Preview {
    CanvasCard(canvas: Canvas(id: UUID(), title: "New canvas", canvas: PKCanvasView(), date: Date.now, userId: ""))
}
