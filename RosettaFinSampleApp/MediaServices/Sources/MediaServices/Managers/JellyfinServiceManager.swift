//
//  JellyfinLoginManager.swift
//  MediaServices
//
//  Created by Kenny Cabral on 4/10/25.
//

import Foundation
import Combine
import JellyfinAPI
import DataModels

@MainActor
public final class JellyfinServiceManager: ObservableObject {
    
    @Published var jellyfinClient: JellyfinClient?
    
    @Published public var isLoggedIn: Bool? = false
    @Published public var accessToken: String? = nil
    
    init(isLoggedIn: Bool = false) {
        self.isLoggedIn = isLoggedIn
    }
    
    public func setupJellyfinClient(
        with urlString: String,
        using token: String? = nil
    ) {
        guard let url = URL(string: urlString) else {
            print("JellyfinServiceManager: Error: No valid URL found when one was expected")
            return
        }
        let config = JellyfinClient.Configuration(
            url: url,
            client: "RosettaFin",
            deviceName: "RosettaFinDevice",
            deviceID: "RosettaFin Id",
            version: "0.0.1")
        jellyfinClient = JellyfinClient(configuration: config, accessToken: token)
        accessToken = jellyfinClient?.accessToken
        isLoggedIn = accessToken != nil
    }
    
    public func attemptLogin(
        serverUrlString: String,
        userName: String,
        password: String,
    ) {
        print("JellyfinServiceManager: serverUrl = \(serverUrlString)")
        print("JellyfinServiceManager: UserName = \(userName)")
        print("JellyfinServiceManager: password = \(password)")
        guard let serverUrl = URL(string: serverUrlString) else {
            print("Error: could not parse URl from \(serverUrlString)")
            return
        }
        
        if jellyfinClient == nil || jellyfinClient?.configuration.url == serverUrl {
            setupJellyfinClient(with: serverUrlString)
        }
        guard let client = jellyfinClient else {
            print("Error: JellyfinClient was nil when a non nil value was expected")
            return
        }
        
        self.isLoggedIn = nil
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                let result = try await client.signIn(username: userName, password: password)
                if let retrievedToken = result.accessToken {
                    let token = retrievedToken
                   await MainActor.run { [weak self] in
                       guard let self else { return }
                       self.accessToken = token
                       self.isLoggedIn = true
                    }
                }
            } catch {
                print("Error returned by server \(error)")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoggedIn = false
                 }
            }
        }
        
    }
}
