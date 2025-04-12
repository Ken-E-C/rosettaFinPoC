// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import JellyfinAPI
import DataModels

@MainActor
public class MediaServices: ObservableObject {
    public static let shared = MediaServices()
    
    public let jellyfinManager = JellyfinServiceManager()
    
    public func setupServices(with jellyfinServerData: JellyfinDataBlob?) {
        if let data = jellyfinServerData {
            let token = data.credentials.first?.accessToken
            jellyfinManager.setupJellyfinClient(with: data.serverUrl, using: token)
        }
    }
}
