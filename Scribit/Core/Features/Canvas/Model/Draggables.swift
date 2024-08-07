//
//  Draggables.swift
//  Scribit
//
//  Created by Godwin IE on 07/08/2024.
//

import SwiftUI

struct DraggableShape: Identifiable {
    var id = UUID()
    var position: CGPoint
    var type: ShapeType
}

enum ShapeType {
    case rectangle, circle, triangle
}

struct DraggableText: Identifiable {
    var id = UUID()
    var position: CGPoint
    var text: String
}
