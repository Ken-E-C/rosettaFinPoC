// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AVFoundation
import Combine
import DataModels

@MainActor
public final class PlaybackManager: ObservableObject {
    public static let shared = PlaybackManager()
    let player = AVPlayer()
    
    @Published public var isPlaying: Bool = false
    @Published public var currentMedia: MusicInfo?
    
    var playerStatusCancellable: AnyCancellable?
    
    init() {
        setupStatusCancellable(for: player)
    }
    
    public func startPlaying(song: MusicInfo, from url: URL) {
        currentMedia = song
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    public func playExisting() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func stop() {
        player.pause()
        currentMedia = nil
    }
    
    private func setupStatusCancellable(for player: AVPlayer) {
        playerStatusCancellable = player.publisher(for: \.timeControlStatus)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
                guard let self else { return }
                self.isPlaying = status == .playing
            })
    }
}

