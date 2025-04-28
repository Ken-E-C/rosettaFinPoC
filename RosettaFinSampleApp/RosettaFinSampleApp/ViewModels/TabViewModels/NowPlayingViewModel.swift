//
//  NowPlayingViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine
import PlaybackServices

@MainActor
final class NowPlayingViewModel: ObservableObject {
    enum ButtonType {
        case back
        case playpause
        case forward
    }
    
    enum PlaybackState {
        case play
        case pause
        case stop
    }
    
    let playbackManager: PlaybackManager
    var playbackCancellable: AnyCancellable?
    
    @Published var currentState: PlaybackState = .stop
    @Published var currentSongTitle: String = "Nil"
    @Published var currentArtistName: String = "Nil"
    
    init(playbackManager: PlaybackManager? = nil) {
        self.playbackManager = playbackManager ?? PlaybackManager.shared
        setupMediaDataListeners(for: self.playbackManager)
    }
    
    func setupMediaDataListeners(for manager: PlaybackManager?) {
        guard let manager else { return }
        playbackCancellable = manager.$currentMedia.receive(on: DispatchQueue.main).sink { [weak self] nowPlayingMedia in
            guard let self else { return }
            self.currentSongTitle = nowPlayingMedia?.name ?? "No Song Title"
            self.currentArtistName = nowPlayingMedia?.artist ?? "No Artist Name"
        }
    }
    
    func didTap(_ button: ButtonType) {
        switch button {
        case .back:
            print("NowPlayingViewmodel: Did Tap back")
        case .playpause:
            print("NowPlayingViewmodel: Did Tap playpause")
            if playbackManager.isPlaying {
                playbackManager.pause()
            } else {
                playbackManager.playExisting()
            }
        case .forward:
            print("NowPlayingViewmodel: Did Tap forward")
        }
    }
}
