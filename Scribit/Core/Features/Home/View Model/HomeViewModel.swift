//
//  HomeViewModel.swift
//  Scribit
//
//  Created by Godwin IE on 11/08/2024.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var columns = [GridItem(.adaptive(minimum: 160), spacing: 18)]
    
    @Published var isNavigatingToCanvasView = false
    @Published var showCreateNew = false
    @Published var showProfile = false

}
