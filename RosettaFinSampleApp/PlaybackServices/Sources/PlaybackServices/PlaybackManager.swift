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
    var timeObserver: Any?
    
    @Published public var isPlaying: Bool = false
    @Published public var currentMedia: MusicInfo?
    
    @Published public private(set) var duration: TimeInterval = 0.0
    @Published public private(set) var currentTime: TimeInterval = 0.0
    
    var playerStatusCancellable: AnyCancellable?
    
    init() {
        setupStatusCancellable(for: player)
    }
    
    public func startPlaying(song: MusicInfo, from url: URL) {
        currentMedia = song
        let item = AVPlayerItem(url: url)
        removeTimeObserver()
        player.replaceCurrentItem(with: item)
        addTimeObserver()
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
    
    private func removeTimeObserver() {
        guard let timeObserver else {
            print("Warning: no time observer was defined")
            return
        }
        
        player.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self else { return }
            
            // This is a hack to make AVPlayer and Swift 6 play nice together.
            Task { @MainActor in
                self.currentTime = time.seconds
                self.duration = self.player.currentItem?.duration.seconds ?? 0.0
                
            }
        })
    }
}

