//
//  SearchViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Combine

class SearchViewModel: ObservableObject {
    @Published var enqueuedSongs = [SongInfo]()
    
    init() {
        setupMockSongs()
    }
    
    private func setupMockSongs() {
        enqueuedSongs = [
            SongInfo(name: "Bohemian Rhapsody", artist: "Queen"),
            SongInfo(name: "Imagine", artist: "John Lennon"),
            SongInfo(name: "Never Gonna Give You Up", artist: "Rick Astley"),
            SongInfo(name: "Hey Jude", artist: "The Beatles"),
        ]
    }
}
