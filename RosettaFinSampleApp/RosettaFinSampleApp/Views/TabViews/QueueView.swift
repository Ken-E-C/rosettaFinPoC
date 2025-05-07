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
        ZStack {
            listLayer
            controlsLayer
        }
        .onReceive(viewModel.$enqueuedSongs) { newSongs in
            enqueuedSongs = newSongs
        }
        .onAppear {
            viewModel.loadSelectedSongs()
        }
    }
    
    var listLayer: some View {
        List {
            ForEach(Array(enqueuedSongs.enumerated()), id: \.element.id) { index, song in
                SongListItem(
                    name: song.name,
                    artist: song.artist) {
                        viewModel.startPlaying(songAt: index)
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 5)
    }
    
    var controlsLayer: some View {
        VStack {
            Spacer()
            FloatingBar {
                HStack {
                    Button {
                        viewModel.playQueue()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Play Queue")
                            Spacer()
                        }
                    }
                }
            }
            .padding(.bottom, 20.0)
        }
    }
}
