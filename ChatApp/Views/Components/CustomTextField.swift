//
//  CustomTextField.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 50)
        }
    }
}
