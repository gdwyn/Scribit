//
//  CreateView.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI

struct CreateView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var canvasTitle = ""

    var body: some View {
        NavigationStack {
            HStack(spacing: 18) {
                TextField("Enter title", text: $canvasTitle)
                    .font(.title.bold())
                    .foregroundStyle(.dark)
                
                Button {
                    Task {
                        await canvasVM.createCanvas(title: canvasTitle)
                    }
                    dismiss()
                } label: {
                    Text("Create")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.accent, in: .capsule)
                        .foregroundStyle(.white)
                        .opacity(canvasTitle.isEmpty ? 0.5 : 1)
                }
                .disabled(canvasTitle.isEmpty)
                
            }
            .padding(.top, 14)
            .padding(.horizontal)
            .navigationTitle("Create new canvas")
            .navigationBarTitleDisplayMode(.inline)
            
            Spacer()
        }
    }
}

#Preview {
    CreateView()
}
