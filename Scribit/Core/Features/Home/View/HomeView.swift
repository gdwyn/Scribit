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
    @EnvironmentObject var authVM: AuthViewModel
        
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                switch homeVM.loadingState {
                case .none:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .success:
                    if !homeVM.canvasList.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid (columns: homeVM.columns) {
                                ForEach(homeVM.canvasList.reversed()) { canvas in
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
                case .error(let message):
                    Text("Error: \(message)").foregroundColor(.red)
                }
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $homeVM.showCreateNew) {
                CreateView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $homeVM.showProfile) {
                ProfileView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .toolbar { HomeToolBar() }
            .refreshable {
                await homeVM.fetchCanvases()
            }
            
        }
    }
}

#Preview {
    HomeView()
}
