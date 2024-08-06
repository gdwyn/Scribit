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
                        vm.toolPicker.setVisible(true, forFirstResponder: vm.canvas)
                        vm.toolPicker.addObserver(vm.canvas)
                        vm.canvas.becomeFirstResponder()
                        vm.toolSelected = true
                    }
                } label: {
                    Image(systemName: "paintbrush.pointed")
                        .font(.title3)
                        .fontWeight(.medium)

                }
                
                Button {
                
                } label: {
                    Image(systemName: "triangle")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
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
