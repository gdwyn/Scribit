//
//  ToolPickerView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI

struct ToolPickerView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @State private var showChat = false
    
    var body: some View {
        if !canvasVM.toolSelected {

            HStack(spacing: 24) {
                Button {
                    withAnimation {
                        canvasVM.showToolPicker()
                    }
                } label: {
                    Image(systemName: "paintbrush.pointed")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        canvasVM.showShapes = true
                    }
                } label: {
                    Image(systemName: "triangle")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        canvasVM.addText(at: CGPoint(x: 100, y: 100))
                    }
                } label: {
                    Image(systemName: "character.textbox")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        showChat = true
                    }
                } label: {
                    Image(systemName: "message.badge.waveform")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                Button {
                    withAnimation {
                        canvasVM.showclearCanvas = true
                    }
                } label: {
                    Image(systemName: "xmark.bin")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                }
            }
            .sheet(isPresented: $showChat) {
                ChatView()
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
