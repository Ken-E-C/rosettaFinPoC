//
//  JellyfinLoginManager.swift
//  MediaServices
//
//  Created by Kenny Cabral on 4/10/25.
//

import Combine
import JellyfinAPI

@MainActor
public final class JellyfinLoginManager: ObservableObject {
    @Published public var isLoggedIn = false
    
    public func attemptLogin(
        serverUrl: String,
        userName: String,
        password: String,
    ) {
        print("JellyfinSetupViewModel: serverUrl = \(serverUrl)")
        print("JellyfinSetupViewModel: UserName = \(userName)")
        print("JellyfinSetupViewModel: password = \(password)")
        isLoggedIn = true
    }
}
