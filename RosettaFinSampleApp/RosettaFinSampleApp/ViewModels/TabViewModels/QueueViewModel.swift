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
        guard let queuedSongsDict = storageServices.massStorageManager.loadQueue()?.enqueuedSongs else {
            print("Warning: No songs found in persistent storage")
            return
        }
        enqueuedSongs = Array(queuedSongsDict.values)
    }
    
    func startPlaying(_ song: MusicInfo) {
        playbackServices.startPlaying(song: song)
    }
    
}
