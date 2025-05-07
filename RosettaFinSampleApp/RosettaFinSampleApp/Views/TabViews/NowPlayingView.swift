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
    
    @State var currentTime: TimeInterval = 0.0
    @State var currentDuration: TimeInterval = 0.0
    @State var durationTextWidth: CGFloat = 0
    
    init(givenViewModel: NowPlayingViewModel? = nil) {
        let viewModel = givenViewModel ?? NowPlayingViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {
            mediaInfoLayer
            controlsLayer
        }
        .onReceive(viewModel.$currentSongTitle) { newTitle in
            currentTitle = newTitle
        }
        .onReceive(viewModel.$currentArtistName) { newName in
            currentArtist = newName
        }
        .onReceive(viewModel.$currentSongImageUrl) { newImageUrl in
            currentSongImageUrl = newImageUrl
        }
        .onReceive(viewModel.$currentTime) { newCurrentTime in
            currentTime = newCurrentTime
        }
        .onReceive(viewModel.$currentDuration) { newCurrentDuration in
            currentDuration = newCurrentDuration
        }
    }
    
    var mediaInfoLayer: some View {
        VStack(alignment: .center) {
            imageSection
            songInfo
        }
        .padding()
    }
    
    var controlsLayer: some View {
        VStack {
            Spacer()
            FloatingBar {
                VStack {
                    scrubberSlider
                    playbackControls
                }
                .padding()
            }
            .padding(.bottom, 20.0)
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
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 250, height: 250)
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
    
    var scrubberSlider: some View {
        HStack {
            Text(currentTime.asString)
                .frame(width: durationTextWidth)
            Slider(value: $currentTime, in: 0...currentDuration) { isChanging in
                if !isChanging {
                    viewModel.seek(to: currentTime)
                }
            }
            Text(currentDuration.asString)
                .padding(.horizontal, 5)
                .background {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            durationTextWidth = geometry.size.width
                        }
                        .onChange(of: geometry.size.width) { _, newValue in
                            durationTextWidth = newValue
                        }
                }
                .frame(height: 50)
            }
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

fileprivate extension TimeInterval {
    var asString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading // drop leading zero values
        return formatter.string(from: self) ?? "hh:mm:ss"
    }
}
