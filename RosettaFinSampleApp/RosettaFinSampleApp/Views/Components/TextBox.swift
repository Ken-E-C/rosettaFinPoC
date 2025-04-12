//
//  TextBox.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import SwiftUI

struct TextBox: View {
    let placeholderText: String
    let isSecure: Bool
    let disableAutocorrect: Bool
    @Binding var inputText: String
    
    init(placeholderText: String,
         inputText: Binding<String>,
         isSecure: Bool = false,
         disableAutocorrect: Bool = false
    ) {
        self.placeholderText = placeholderText
        self.isSecure = isSecure
        self.disableAutocorrect = disableAutocorrect
        _inputText = inputText
    }
    
    var body: some View {
        VStack {
            if isSecure {
                SecureField(placeholderText, text: $inputText)
            } else {
                TextField(text: $inputText) {
                    Text(placeholderText)
                }
                .autocorrectionDisabled(disableAutocorrect)
            }
            Divider()
        }
        .padding(.vertical, 8.0)
    }
}
