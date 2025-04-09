//
//  SearchBar.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for Song...", text: $searchText)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 5)
        .padding()
    }
}
