//
//  SearchView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI
import DataModels

struct SearchView: View {
    typealias ListItemInfo = SearchViewModel.ListItemInfo
    @StateObject var viewModel: SearchViewModel
    @State var enqueuedSongs = [ListItemInfo]()
    
    init(givenViewModel: SearchViewModel? = nil) {
        let viewModel = givenViewModel ?? SearchViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            listLayer
            searchLayer
        }
        .onReceive(viewModel.$searchResults) { newSongs in
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
                ForEach(enqueuedSongs, id: \.musicInfo.id) { info in
                    SongListItem(
                        name: info.musicInfo.name,
                        artist: info.musicInfo.artist) {
                        info.isSelected ? Image(systemName: "circle.fill") : Image(systemName: "circle")
                    } tapAction: {
                        viewModel.didSelect(info)
                    }
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5)
            .padding()
        }
    }
}
