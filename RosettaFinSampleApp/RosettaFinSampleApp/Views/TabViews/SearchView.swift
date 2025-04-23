//
//  SearchView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI
import DataModels

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State var enqueuedSongs = [MusicInfo]()
    
    init(givenViewModel: SearchViewModel? = nil) {
        let viewModel = givenViewModel ?? SearchViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            listLayer
            searchLayer
        }
        .onReceive(viewModel.$enqueuedSongs) { newSongs in
            enqueuedSongs = newSongs
        }
    }
    
    var searchLayer: some View {
        VStack {
            Spacer()
            SearchBar(searchText: $viewModel.searchText)
                .padding(.bottom, 20.0)
        }
        
    }
    
    var listLayer: some View {
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
    }
}
