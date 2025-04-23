// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import JellyfinAPI
import DataModels

@MainActor
public class MediaServices: ObservableObject {
    
    public enum MediaType {
        case music
    }
    
    public static let shared = MediaServices()
    
    public let jellyfinManager = JellyfinServiceManager()
    
    public func setupServices(with jellyfinServerData: JellyfinDataBlob?) {
        if let data = jellyfinServerData {
            let token = data.getLastUser()?.accessToken
            jellyfinManager.setupJellyfinClient(with: data.serverUrl, using: token)
        }
    }
    
    public func search(
        for type: MediaType,
        using keyword: String,
        userId: String,
        callback: @escaping ([MusicInfo]) -> Void) throws {
            
            Task.detached(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    let jellyfinMusicResults = try await self.jellyfinManager.search(for: type, using: keyword, userId: userId)
                    
                    let musicResults = jellyfinMusicResults
                    await MainActor.run {
                        callback(musicResults)
                    }
                } catch {
                    print("Error: Unable to complete search query \(error)")
                    await MainActor.run {
                        callback([])
                    }
                    return
                }
                
            }
    }
}
