//
//  HomeToolBar.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI

struct HomeToolBar: ToolbarContent {
    @EnvironmentObject var canvasVM: CanvasViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
               
            } label: {
                Image("userprofile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CollabView()
                } label: {
                    HStack {
                        Image(systemName: "dot.radiowaves.left.and.right")
                        Text("Collaborate")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.green)
                    
                }
            }
            
            if !canvasVM.canvasList.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await canvasVM.createCanvas(title: "New canvas")
                        }
                    } label: {
                        Text("New")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.accent, in: .capsule)
                            .foregroundStyle(.white)
                    }
                    
                }
            }

    }
}

#Preview {
    HomeToolBar() as! any View
}
