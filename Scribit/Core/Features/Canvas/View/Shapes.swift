//
//  Shapes.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct ShapeView: View {
    let shape: DraggableShape

    var body: some View {
        switch shape.type {
        case .rectangle:
            Rectangle().frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .overlay(
                    Rectangle()
                        .stroke(lineWidth: 1)
                )
        case .circle:
            Circle()
                .frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .overlay(
                    Circle()
                        .stroke(lineWidth: 1)
                )
        case .elipse:
            Oval()
                .frame(width: 120, height: 60)
                .foregroundStyle(.white)
                .overlay(
                    Oval()
                        .stroke(lineWidth: 1)
                )
        case .triangle:
            Triangle().frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .overlay(
                    Triangle()
                        .stroke(lineWidth: 1)
                )
        case .star:
            Star().frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .overlay(
                    Star()
                        .stroke(lineWidth: 1)
                )
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        return path
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let points = 5
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let angleIncrement = .pi * 2 / Double(points)
        let startAngle = -3.2 / 2
        
        var path = Path()
        
        for i in 0..<points {
            let outerAngle = startAngle + angleIncrement * Double(i) * 2
            let innerAngle = outerAngle + angleIncrement
            
            let outerPoint = CGPoint(
                x: center.x + outerRadius * CGFloat(cos(outerAngle)),
                y: center.y + outerRadius * CGFloat(sin(outerAngle))
            )
            let innerPoint = CGPoint(
                x: center.x + innerRadius * CGFloat(cos(innerAngle)),
                y: center.y + innerRadius * CGFloat(sin(innerAngle))
            )
            
            if i == 0 {
                path.move(to: outerPoint)
            }
            
            path.addLine(to: outerPoint)
            path.addLine(to: innerPoint)
        }
        
        path.closeSubpath()
        
        return path
    }
}

