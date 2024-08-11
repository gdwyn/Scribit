//
//  AppPasswordField.swift
//  Scribit
//
//  Created by Godwin IE on 08/08/2024.
//

import SwiftUI

struct AppPasswordField: View {
    var title: String
    var placeHolder: String
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.callout)
                
            SecureField(placeHolder, text: $password)
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
    AppPasswordField(title: "Password", placeHolder: "Enter password", password: .constant("password"))
}
