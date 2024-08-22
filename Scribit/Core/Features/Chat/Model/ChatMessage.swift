//
//  ChatMessage.swift
//  Scribit
//
//  Created by Godwin IE on 21/08/2024.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let canvasId: String
    let userId: String
    var message: String
    let timestamp: Date
}
