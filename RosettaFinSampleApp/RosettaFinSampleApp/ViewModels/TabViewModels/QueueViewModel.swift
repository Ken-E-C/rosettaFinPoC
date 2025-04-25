//
//  QueueViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Combine
import DataModels
import MediaServices
import StorageServices

@MainActor
class QueueViewModel: ObservableObject {
    @Published var enqueuedSongs = [MusicInfo]()
    
    var mediaServices: MediaServices
    var storageServices: StorageServices
    
    init(mediaServices: MediaServices? = nil, storageServices: StorageServices? = nil) {
        self.mediaServices = mediaServices ?? MediaServices.shared
        self.storageServices = storageServices ?? StorageServices.shared
        // loadSelectedSongs()
    }
    
    func loadSelectedSongs() {
        guard let queuedSongsDict = storageServices.massStorageManager.loadQueue()?.enqueuedSongs else {
            print("Warning: No songs found in persistent storage")
            return
        }
        enqueuedSongs = Array(queuedSongsDict.values)
    }
}
