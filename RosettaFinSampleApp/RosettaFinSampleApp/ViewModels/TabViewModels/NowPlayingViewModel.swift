//
//  NowPlayingViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine

class NowPlayingViewModel: ObservableObject {
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
    
    @Published var currentState: PlaybackState = .stop
    @Published var currentSongTitle: String = "No Song Title"
    @Published var currentArtistName: String = "No Artist Name"
    
    func didTap(_ button: ButtonType) {
        switch button {
        case .back:
            print("NowPlayingViewmodel: Did Tap back")
        case .playpause:
            print("NowPlayingViewmodel: Did Tap playpause")
        case .forward:
            print("NowPlayingViewmodel: Did Tap forward")
        }
    }
}
