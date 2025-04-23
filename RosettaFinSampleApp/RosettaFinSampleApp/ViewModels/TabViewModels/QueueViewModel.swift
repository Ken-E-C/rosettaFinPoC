//
//  QueueViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Combine
import DataModels

class QueueViewModel: ObservableObject {
    @Published var enqueuedSongs = [MusicInfo]()
    
    init() {
        setupMockSongs()
    }
    
    private func setupMockSongs() {
        enqueuedSongs = [
            MusicInfo(name: "Bohemian Rhapsody", artist: "Queen"),
            MusicInfo(name: "Imagine", artist: "John Lennon"),
            MusicInfo(name: "Never Gonna Give You Up", artist: "Rick Astley"),
            MusicInfo(name: "Hey Jude", artist: "The Beatles"),
        ]
    }
}
