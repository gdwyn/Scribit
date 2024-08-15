//
//  HomeView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var canvasVM: CanvasViewModel
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                if !canvasVM.canvasList.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid (columns: homeVM.columns) {
                            ForEach(canvasVM.canvasList.reversed()) { canvas in
                                CanvasCard(canvas: canvas)
                            }
                        }
                    }
                    
                    NavigationLink(destination: CanvasView(), isActive: $homeVM.isNavigatingToCanvasView) {
                        EmptyView()
                    }
                    
                } else {
                    EmptyListView()
                }
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $homeVM.showCreateNew) {
                CreateView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $homeVM.showProfile) {
                ProfileView(appUser: $appUser)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .toolbar {HomeToolBar()}
            .refreshable {
                await canvasVM.fetchCanvases()
            }
            
        }
        .task {
            await canvasVM.fetchCanvases()
        }
    }
}

#Preview {
    HomeView(appUser: .constant(.init(uid: "1234", email: nil)))
}
