//
//  GestureModifier.swift
//  Scribit
//
//  Created by Godwin IE on 07/08/2024.
//

import Foundation
import SwiftUI

struct ConditionalGestureModifier<GestureType: Gesture>: ViewModifier {
    var condition: Bool
    var gesture: GestureType

    func body(content: Content) -> some View {
        if condition {
            content
                .contentShape(Rectangle())
                .gesture(gesture)
        } else {
            content
        }
    }
}

extension View {
    func conditionalGesture<GestureType: Gesture>(_ condition: Bool, _ gesture: GestureType) -> some View {
        self.modifier(ConditionalGestureModifier(condition: condition, gesture: gesture))
    }
}

