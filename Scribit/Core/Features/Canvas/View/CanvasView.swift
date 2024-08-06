//
//  CanvasView.swift
//  Scribit
//
//  Created by Godwin IE on 06/08/2024.
//

import PencilKit
import SwiftUI

struct CanvasView: View {
    @State private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                DottedBackgroundView(dotColor: .accent.opacity(0.2), vm: $vm)
                    .navigationBarTitleDisplayMode(.inline)
                
                VStack {
                    CanvasToolBar(vm: vm)
                    
                    Spacer()
                    
                    ToolPickerView(vm: vm)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CanvasView()
}
