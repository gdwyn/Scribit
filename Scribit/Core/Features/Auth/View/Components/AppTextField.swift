//
//  AppTextField.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct AppTextField: View {
    var title: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.callout)
                
            TextField(placeHolder, text: $text)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
    }
}


#Preview {
    AppTextField(title: "Email", placeHolder: "Enter text", text: .constant("hey@gmail.com"))
}
