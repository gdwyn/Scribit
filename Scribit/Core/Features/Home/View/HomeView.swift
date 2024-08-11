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
    
    @State var isNavigatingToCanvasView = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                if !canvasVM.canvasList.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid (columns: homeVM.columns, spacing: 14) {

                            ForEach(canvasVM.canvasList) { canvas in
                                
                                Button {
                                    canvasVM.currentCanvas = canvas
                                    isNavigatingToCanvasView = true
                                } label: {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Image("scribempty")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 90)
                                            .padding(16)
                                            .background(.gray.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(canvas.title)
                                                .font(.headline)
                                                .foregroundStyle(.dark)
                                            
                                            Text(homeVM.formattedDate(canvas.date))
                                                .font(.callout)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    .padding(.top, 18)
                                }
                                
                            }
                            
                        }
                    }
                    
                    NavigationLink(destination: CanvasView(), isActive: $isNavigatingToCanvasView) {
                        EmptyView()
                    }
                } else {
                    EmptyListView()
                }
                
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        canvasVM.createCanvas(title: "New canvas")
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            do {
                                try await AuthManager.shared.signOut()
                                self.appUser = nil
                            } catch {
                                print("unable to sign out")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .rotationEffect(.degrees(180))
                            Text("Log out")
                        }
                        .font(.callout)
                        .foregroundStyle(.gray)
                    }
                }
            }
            
        }
    }
}

#Preview {
    HomeView(appUser: .constant(.init(uid: "1234", email: nil)))
}
