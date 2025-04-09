//
//  TextBox.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import SwiftUI

struct TextBox: View {
    let placeholderText: String
    @Binding var inputText: String
    
    var body: some View {
        VStack {
            TextField(text: $inputText) {
                Text(placeholderText)
            }
            Divider()
        }
        .padding(.vertical, 8.0)
    }
}
