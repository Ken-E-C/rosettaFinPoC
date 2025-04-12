// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import JellyfinAPI
import DataModels

@MainActor
public class MediaServices: ObservableObject {
    public static let shared = MediaServices()
    
    var jellyfinClient: JellyfinClient?
    
    public let jellyfinLoginManager = JellyfinLoginManager()
    
    public func setupServices(with jellyfinServerData: JellyfinDataBlob?) {
        if let data = jellyfinServerData {
            let token = data.credentials.first?.accessToken
            setupJellyfinClient(with: data.serverUrl, using: token)
        }
    }
    
    public func setupJellyfinClient(with urlString: String, using token: String?) {
        guard let url = URL(string: urlString) else {
            print("MediaServices: Error: No valid URL found when one was expected")
            return
        }
        let config = JellyfinClient.Configuration(
            url: url,
            client: "RosettaFin",
            deviceName: "RosettaFinDevice",
            deviceID: "RosettaFin Id",
            version: "0.0.1")
        jellyfinClient = JellyfinClient(configuration: config, accessToken: token)
    }
}
