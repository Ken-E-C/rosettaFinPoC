//
//  QueueViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine

class QueueViewModel: ObservableObject {
    struct SongInfo: Identifiable {
        var id: String {
            name + artist
        }
        
        let name: String
        let artist: String
    }
    
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
