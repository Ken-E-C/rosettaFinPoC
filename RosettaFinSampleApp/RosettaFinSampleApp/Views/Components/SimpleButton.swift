//
//  SimpleButton.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import SwiftUI

struct SimpleButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 30)
        .buttonStyle(.plain)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
