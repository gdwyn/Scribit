//
//  HomeToolBar.swift
//  Scribit
//
//  Created by Godwin IE on 14/08/2024.
//

import SwiftUI

struct HomeToolBar: ToolbarContent {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var canvasVM: CanvasViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                homeVM.showProfile = true
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
                        Image(systemName: "person.line.dotted.person.fill")
                        Text("Collaborate")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    
                }
            }
            
            if !homeVM.canvasList.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        homeVM.showCreateNew = true
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
