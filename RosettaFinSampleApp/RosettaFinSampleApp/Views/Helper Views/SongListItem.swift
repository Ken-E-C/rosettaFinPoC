//
//  SongListItem.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//
import SwiftUI

struct SongListItem: View {
    
    let name: String
    let artist: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(artist)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}
