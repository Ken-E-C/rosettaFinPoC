//
//  NowPlayingView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI

fileprivate extension CGFloat {
    static let iconHeight = 30.0
}

struct NowPlayingView: View {
    @StateObject var viewModel: NowPlayingViewModel
    
    @State var currentTitle = "Song Title"
    @State var currentArtist = "Artist Name"
    @State var currentSongImageUrl: URL?
    
    init(givenViewModel: NowPlayingViewModel? = nil) {
        let viewModel = givenViewModel ?? NowPlayingViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            imageSection
            songInfo
            playbackControls
        }
        .padding()
        .onReceive(viewModel.$currentSongTitle) { newTitle in
            currentTitle = newTitle
        }
        .onReceive(viewModel.$currentArtistName) { newName in
            currentArtist = newName
        }
        .onReceive(viewModel.$currentSongImageUrl) { newImageUrl in
            currentSongImageUrl = newImageUrl
        }
    }
    
    var imageSection: some View {
        AsyncImage(url: viewModel.currentSongImageUrl) { phase in
            switch phase {
            case .empty:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(let error):
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
    
    var songInfo: some View {
        VStack(alignment: .center) {
            Text(currentTitle)
                .font(.headline)
            Text(currentArtist)
                .font(.caption)
        }
    }
    
    var playbackControls: some View {
        HStack {
            Spacer()
            Button {
                viewModel.didTap(.back)
            } label: {
                Image(systemName: "backward.end")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: .iconHeight)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button {
                viewModel.didTap(.playpause)
            } label: {
                Image(systemName: "playpause")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: .iconHeight)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button {
                viewModel.didTap(.forward)
            } label: {
                Image(systemName: "forward.end")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: .iconHeight)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
}
