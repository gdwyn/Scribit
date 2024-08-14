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

                            ForEach(canvasVM.canvasList) { canvas in
                                
                                Button {
                                    canvasVM.currentCanvas = canvas
                                    homeVM.isNavigatingToCanvasView = true
                                } label: {
                                    VStack(alignment: .leading, spacing: 14) {
                                        Image("canvasthumbnail")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: 128)
                                            .padding(26)
                                            .background(.accent.opacity(0.05))
                                            .clipShape(RoundedRectangle(cornerRadius: 22))
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(canvas.title)
                                                    .font(.headline)
                                                    .foregroundStyle(.dark)
                                                
                                                Text(homeVM.formattedDate(canvas.date))
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Button {
                                                canvasVM.deleteCanvas(canvas: canvas)
                                            } label: {
                                                Image(systemName: "xmark.bin.fill")
                                                    .padding(8)
                                                    .foregroundStyle(.gray)
                                                    .background(.gray.opacity(0.06), in: Circle())
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(.top, 28)
                                .transition(.scale)
                                .transition(.opacity)
                                
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


//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        Task {
//                            do {
//                                try await Supabase.shared.signOut()
//                                self.appUser = nil
//                            } catch {
//                                print("unable to sign out")
//                            }
//                        }
//                    } label: {
//                        HStack {
//                            Image(systemName: "rectangle.portrait.and.arrow.forward")
//                                .rotationEffect(.degrees(180))
//                            Text("Log out")
//                        }
//                        .font(.callout)
//                        .foregroundStyle(.gray)
//                    }
//                }
