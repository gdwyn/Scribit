//
//  EmptyListView.swift
//  Scribit
//
//  Created by Godwin IE on 11/08/2024.
//

import SwiftUI

struct EmptyListView: View {
    @EnvironmentObject var canvasVM: CanvasViewModel

    var body: some View {
        VStack(spacing: 14) {
            Image("scribempty")
                .resizable()
                .scaledToFit()
                .frame(width: 84)
            
            VStack(spacing: 6) {
                Text("Hey 🤙 Let's scrib")
                    .font(.title3)
                Text("Create your first canvas")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .frame(width: 220)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                Task {
                    await canvasVM.createCanvas(title: "New canvas")
                }
            } label: {
                Text("Start Scribbing")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.accent, in: Capsule())
            }
            .padding(.top, 12)
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    EmptyListView()
}
