//
//  CollaborationView.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI
import PencilKit

struct CollaborationView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @State private var canvasIdInput: String = ""
    @State private var isCollaborating = false
    
    var body: some View {
        VStack {
            TextField("Enter Canvas ID", text: $canvasIdInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.default)
                .disableAutocorrection(true)
            
            Button("Join Collaboration") {
                if let canvasId = UUID(uuidString: canvasIdInput) {
                    Task {
                        await canvasVM.joinCollaboration(with: canvasId)
                        isCollaborating = true
                    }
                }
            }
            .padding()
            .disabled(isCollaborating)

            if isCollaborating {
                CanvasView()
                    .onAppear {
                        canvasVM.subscribeToCanvasChanges(canvasId: canvasVM.currentCanvas.id)
                    }
                    .onDisappear {
                        canvasVM.unsubscribe()
                    }
            }
        }
        .padding()
    }
}

//struct CanvasView: UIViewRepresentable {
//    @Binding var canvas: PKCanvasView
//    @Binding var toolPicker: PKToolPicker
//
//    func makeUIView(context: Context) -> PKCanvasView {
//        canvas
//    }
//
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        toolPicker.setVisible(true, forFirstResponder: uiView)
//        uiView.becomeFirstResponder()
//    }
//}

#Preview {
    CollaborationView()
}
