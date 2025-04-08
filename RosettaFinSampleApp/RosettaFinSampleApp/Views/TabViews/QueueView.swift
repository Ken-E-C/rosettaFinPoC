//
//  QueueView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI

struct QueueView: View {
    typealias SongInfo = QueueViewModel.SongInfo
    
    @StateObject var viewModel: QueueViewModel
    @State var enqueuedSongs = [SongInfo]()
    
    init(viewModel: QueueViewModel = QueueViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(enqueuedSongs) { song in
                    SongListItem(name: song.name, artist: song.artist)
                }
            }
            .padding()
        }
        .onReceive(viewModel.$enqueuedSongs) { newSongs in
            enqueuedSongs = newSongs
        }
    }
}
