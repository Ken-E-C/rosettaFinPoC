//
//  QueueViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine
import DataModels
import MediaServices
import StorageServices
import PlaybackServices

@MainActor
class QueueViewModel: ObservableObject {
    @Published var enqueuedSongs = [MusicInfo]()
    
    var mediaServices: MediaServices
    var storageServices: StorageServices
    var playbackServices: PlaybackManager
    
    init(
        mediaServices: MediaServices? = nil,
        storageServices: StorageServices? = nil,
        playbackServices: PlaybackManager? = nil) {
        self.mediaServices = mediaServices ?? MediaServices.shared
        self.storageServices = storageServices ?? StorageServices.shared
            self.playbackServices = playbackServices ?? PlaybackManager.shared
    }
    
    func loadSelectedSongs() {
        guard let queuedSongs = storageServices.massStorageManager.loadQueue()?.enqueuedSongs else {
            print("Warning: No songs found in persistent storage")
            return
        }
        enqueuedSongs = queuedSongs
        playbackServices.loadQueue(using: queuedSongs)
    }
    
    func startPlaying(songAt index: Int) {
        playbackServices.startPlaying(songAt: index)
    }
    
    func playQueue() {
        playbackServices.playNext()
    }
    
}
