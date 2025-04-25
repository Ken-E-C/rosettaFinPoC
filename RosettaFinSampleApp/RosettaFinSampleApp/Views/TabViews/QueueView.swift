//
//  QueueView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI
import DataModels

struct QueueView: View {
    @StateObject var viewModel: QueueViewModel
    @State var enqueuedSongs = [MusicInfo]()
    
    init(givenViewModel: QueueViewModel? = nil) {
        let viewModel = givenViewModel ?? QueueViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(enqueuedSongs) { song in
                    SongListItem(name: song.name, artist: song.artist)
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5)
            .padding()
        }
        .onReceive(viewModel.$enqueuedSongs) { newSongs in
            enqueuedSongs = newSongs
        }
        .onAppear {
            viewModel.loadSelectedSongs()
        }
    }
}
