//
//  NowPlayingViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine
import PlaybackServices
import MediaServices
import DataModels

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
    let mediaServices: MediaServices
    var playbackCancellables = Set<AnyCancellable>()
    
    @Published var currentState: PlaybackState = .stop
    @Published var currentSongTitle: String = "Nil"
    @Published var currentArtistName: String = "Nil"
    @Published var currentSongImageUrl: URL?
    
    @Published var currentTime: TimeInterval = 0.0
    @Published var currentDuration: TimeInterval = 0.0
    
    init(playbackManager: PlaybackManager? = nil,
         mediaServices: MediaServices? = nil) {
        self.playbackManager = playbackManager ?? PlaybackManager.shared
        self.mediaServices = mediaServices ?? MediaServices.shared
        setupMediaDataListeners(for: self.playbackManager)
        setupScrubberBindings(for: self.playbackManager)
    }
    
    func setupMediaDataListeners(for manager: PlaybackManager?) {
        guard let manager else { return }
        manager.$currentMedia.receive(on: DispatchQueue.main).sink { [weak self] nowPlayingMedia in
            guard let self else { return }
            self.currentSongTitle = nowPlayingMedia?.name ?? "No Song Title"
            self.currentArtistName = nowPlayingMedia?.artist ?? "No Artist Name"
            self.loadArtwork(for: nowPlayingMedia)
        }.store(in: &playbackCancellables)
    }
    
    func setupScrubberBindings(for manager: PlaybackManager?) {
        guard let manager else { return }
        manager.$currentTime.receive(on: DispatchQueue.main).sink { [weak self] newTime in
            guard let self else { return }
            self.currentTime = newTime
        }.store(in: &playbackCancellables)
        
        manager.$duration.receive(on: DispatchQueue.main).sink { [weak self] newDuration in
            guard let self else { return }
            self.currentDuration = newDuration
        }.store(in: &playbackCancellables)
    }
    
    func seek(to newTime: TimeInterval) {
        playbackManager.seek(to: newTime)
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
    
    func loadArtwork(for media: MusicInfo?) {
        guard let media else {
            print("Warning: No media found while loading artwork.")
            return
        }

        self.currentSongImageUrl = media.artworkUrl
    }
}
