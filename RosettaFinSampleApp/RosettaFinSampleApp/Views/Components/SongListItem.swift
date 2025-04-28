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
    let tapAction: (() -> Void)?
    
    init(
        name: String,
        artist: String,
        content: @escaping () -> Content,
        tapAction: (() -> Void)? = nil)
    {
        self.name = name
        self.artist = artist
        self.content = content
        self.tapAction = tapAction
    }
    
    init(name: String, artist: String, tapAction: (() -> Void)? = nil) where Content == EmptyView {
        self.name = name
        self.artist = artist
        self.content = { EmptyView() }
        self.tapAction = tapAction
    }
    
    var body: some View {
        Button {
            tapAction?()
        } label: {
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
        .disabled(tapAction == nil)
    }
}
