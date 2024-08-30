//
//  CreateView.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI

struct CreateView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var canvasTitle = ""

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "applepencil.and.scribble")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .padding(24)
                    .background(.accent.opacity(0.06), in: Circle())
                
                Text ("Create new canvas")
                
                VStack(spacing: 14) {
                    TextField("Enter title", text: $canvasTitle)
                        .font(.title.bold())
                        .foregroundStyle(.dark)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        Task {
                            await homeVM.createCanvas(title: canvasTitle)
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
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CreateView()
}
