// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AVFoundation
import Combine
import DataModels

@MainActor
public final class PlaybackManager: ObservableObject {
    
    // Hack to make completion calls work with AVPlayer
    typealias SnapshotCompletion = @Sendable @MainActor () -> Void
    
    public static let shared = PlaybackManager()
    let player = AVPlayer()
    var timeObserver: Any?
    
    @Published public private(set) var isPlaying: Bool = false
    @Published public private(set) var currentMedia: MusicInfo?
    
    @Published public private(set) var queue: [MusicInfo]?
    @Published public private(set) var currentIndex: Int?
    
    @Published public private(set) var duration: TimeInterval = 0.0
    @Published public private(set) var currentTime: TimeInterval = 0.0
    
    var playerStatusCancellable: AnyCancellable?
    
    init() {
        setupStatusCancellable(for: player)
    }
    
    public func loadQueue(using newQueue: [MusicInfo]) {
        queue = newQueue
        currentIndex = nil
    }
    
    public func startPlaying(songAt index: Int) {
        guard let song = queue?[index] else {
            print("Warning: song at index \(index) not found")
            return
        }
        currentIndex = index
        startPlaying(song: song)
    }
    
    public func startPlaying(song: MusicInfo) {
        guard let streamingUrl = song.streamingUrl else {
            print("Error: can't generate streamingUrl for song \(song.name)")
            return
        }
        currentMedia = song
        let item = AVPlayerItem(url: streamingUrl)
        removeTimeObserver()
        player.replaceCurrentItem(with: item)
        addTimeObserver()
        player.play()
    }
    
    public func playExisting() {
        player.play()
    }
    
    public func playNext() {
        guard let queue else {
            print("Warning: no queue was loaded")
            return
        }
        
        let nextIndex: Int = {
            if let currentIndex {
                return currentIndex + 1
            } else {
                return 0
            }
        }()

        guard queue.count > nextIndex else {
            print("Info: End of queue reached")
            return
        }
        
        self.currentIndex = nextIndex
        startPlaying(songAt: nextIndex)
    }
    
    public func playPrevious() {
        guard let queue else {
            print("Warning: no queue was loaded")
            return
        }
        
        let prevIndex: Int = {
            if let currentIndex {
                return currentIndex - 1
            } else {
                return 0
            }
        }()

        guard prevIndex >= 0 else {
            print("Info: Start of queue reached")
            return
        }
        
        self.currentIndex = prevIndex
        startPlaying(songAt: prevIndex)
    }
    
    public func pause() {
        player.pause()
    }
    
    public func stop() {
        player.pause()
        currentMedia = nil
    }
    
    public func seek(to timeDouble: Double) {
        let newTime = CMTime(seconds: timeDouble, preferredTimescale: 600)
        player.seek(to: newTime)
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
    
    private func addTimeObserver(_ callback: SnapshotCompletion? = nil) {
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let completionCallback = callback ?? playNext
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self else { return }
            
            // This is a hack to make AVPlayer and Swift 6 play nice together.
            Task { @MainActor in
                if let duration = self.player.currentItem?.duration.seconds, duration.isFinite {
                    self.currentTime = time.seconds
                    self.duration = duration
                    
                    if self.currentTime >= self.duration {
                        completionCallback()
                    }
                }
            }
        })
    }
}

