//
//  SongListItem.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//
import SwiftUI

struct SongListItem<Content: View>: View {
    
    let name: String
    let artist: String
    let content: () -> Content
    
    init(
        name: String,
        artist: String,
        content: @escaping () -> Content) {
        self.name = name
        self.artist = artist
        self.content = content
    }
    
    init(name: String, artist: String) where Content == EmptyView {
        self.name = name
        self.artist = artist
        self.content = { EmptyView() }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(artist)
                    .font(.subheadline)
            }
            Spacer()
            content()
        }
        .padding()
    }
}
