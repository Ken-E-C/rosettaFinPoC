//
//  FloatingBar.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 5/7/25.
//

import SwiftUI

struct FloatingBar<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        HStack {
            content()
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 5)
        .padding()
    }
}
