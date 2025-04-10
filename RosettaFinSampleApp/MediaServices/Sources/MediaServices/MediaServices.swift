// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import JellyfinAPI

@MainActor
public class MediaServices: ObservableObject {
    public static let shared = MediaServices()
    
    public let jellyfinLoginManager = JellyfinLoginManager()
    
    init() {
        
    }
}
