//
//  Canvas.swift
//  Scribit
//
//  Created by Godwin IE on 11/08/2024.
//

import Foundation
import PencilKit

struct Canvas: Identifiable, Equatable {
    let id: UUID
    var title: String
    var canvas: PKCanvasView
    var date: Date
    let userId: String
}
