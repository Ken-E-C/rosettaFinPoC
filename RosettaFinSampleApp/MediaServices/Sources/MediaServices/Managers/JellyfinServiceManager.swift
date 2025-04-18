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
public protocol JellyfinServiceManagerProtocol {
    func attemptLogin(
        serverUrlString: String,
        userName: String,
        password: String
    )
    
    var jellyfinClient: JellyfinClient? { get }
    var jellyfinClientPublisher: Published<JellyfinClient?>.Publisher { get }
    
    var isLoggedIn: Bool? { set get }
    var isLoggedInPublisher: Published<Bool?>.Publisher { get }
    
    var accessToken: String? { set get }
    var accessTokenPublisher: Published<String?>.Publisher { get }
}

@MainActor
public final class JellyfinServiceManager: JellyfinServiceManagerProtocol, ObservableObject {
    
    public enum JellyfinServiceError: Error {
        case loginFailedOnServerSide
    }
    
    @Published public private(set) var jellyfinClient: JellyfinClient?
    public var jellyfinClientPublisher: Published<JellyfinClient?>.Publisher {
        $jellyfinClient
    }
    
    @Published public var isLoggedIn: Bool? = false
    public var isLoggedInPublisher: Published<Bool?>.Publisher {
        $isLoggedIn
    }
    
    @Published public var accessToken: String? = nil
    public var accessTokenPublisher: Published<String?>.Publisher {
        $accessToken
    }
    
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
        callback: @escaping (String?, JellyfinServiceError?) -> Void
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
                       
                       callback(self.accessToken, nil)
                    }
                }
            } catch {
                print("Error returned by server \(error)")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoggedIn = false
                    
                    callback(nil, .loginFailedOnServerSide)
                 }
            }
        }
        
    }
}
