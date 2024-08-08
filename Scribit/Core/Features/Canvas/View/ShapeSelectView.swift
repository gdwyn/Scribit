//
//  shapeSelectView.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct ShapeSelectView: View {
    var vm: CanvasView.ViewModel

    var body: some View {
        HStack(spacing: 24) {
            Button {
                withAnimation {
                    vm.addShape(type: .rectangle, at: CGPoint(x: 100, y: 100))
                    vm.showShapes = false
                }
            } label: {
                Image(systemName: "rectangle")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            
            Button {
                withAnimation {
                    vm.addShape(type: .circle, at: CGPoint(x: 100, y: 100))
                    vm.showShapes = false
                }
            } label: {
                Image(systemName: "circle")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            
            Button {
                withAnimation {
                    vm.addShape(type: .elipse, at: CGPoint(x: 100, y: 100))
                    vm.showShapes = false
                }
            } label: {
                Image(systemName: "oval")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            
            Button {
                withAnimation {
                    vm.addShape(type: .triangle, at: CGPoint(x: 100, y: 100))
                    vm.showShapes = false
                }
            } label: {
                Image(systemName: "triangle")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            
            Button {
                withAnimation {
                    vm.addShape(type: .star, at: CGPoint(x: 100, y: 100))
                    vm.showShapes = false
                }
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            
        }
        .frame(alignment: .bottom)
        .padding(14)
        .background(
            Capsule()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .background(
                    Capsule()
                        .fill(.dark)
        )
        .shadow(color: Color.gray.opacity(0.06), radius: 4, x: 0, y: 4))
        .transition(.scale)
    }
}

