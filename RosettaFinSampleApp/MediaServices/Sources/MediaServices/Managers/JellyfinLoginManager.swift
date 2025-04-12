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
public final class JellyfinLoginManager: ObservableObject {
    @Published public var isLoggedIn: Bool? = false
    @Published public var accessToken: String? = nil
    
    init(isLoggedIn: Bool = false) {
        self.isLoggedIn = isLoggedIn
    }
    
    public func attemptLogin(
        serverUrl: String,
        userName: String,
        password: String,
    ) {
        print("JellyfinSetupViewModel: serverUrl = \(serverUrl)")
        print("JellyfinSetupViewModel: UserName = \(userName)")
        print("JellyfinSetupViewModel: password = \(password)")
        guard let serverUrl = URL(string: serverUrl) else {
            print("Error: could not parse URl from \(serverUrl)")
            return
        }
        
        
//        let configuration = JellyfinClient.Configuration(
//            url: serverUrl,
//            client: "RosettaFin",
//            deviceName: "RosettaFinDevice",
//            deviceID: "RosettaFin Id",
//            version: "0.0.1")
//        let client = JellyfinClient(configuration: configuration)
        self.isLoggedIn = nil
        Task.detached(priority: .userInitiated) {
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
