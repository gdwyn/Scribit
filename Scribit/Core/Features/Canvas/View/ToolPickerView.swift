//
//  ToolPickerView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI

struct ToolPickerView: View {
    var vm: CanvasView.ViewModel

    var body: some View {
        if !vm.toolSelected {

            HStack(spacing: 24) {
                Button {
                    withAnimation {
                        vm.showToolPicker()
                    }
                } label: {
                    Image(systemName: "paintbrush.pointed")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        vm.addShape(type: .triangle, at: CGPoint(x: 100, y: 100))
                    }
                } label: {
                    Image(systemName: "triangle")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        vm.addText(at: CGPoint(x: 100, y: 100))
                    }
                } label: {
                    Image(systemName: "character.textbox")
                        .font(.title3)
                        .fontWeight(.medium)
                }
            }
            .frame(alignment: .bottom)
            .padding(14)
            .background(
                Capsule()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    .background(
                        Capsule()
                            .fill(Color.white)
            )
            .shadow(color: Color.gray.opacity(0.06), radius: 4, x: 0, y: 4))
            .transition(.scale)
        }
    }
}
