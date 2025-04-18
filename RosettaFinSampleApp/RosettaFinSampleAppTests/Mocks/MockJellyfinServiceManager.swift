//
//  MockJellyfinServiceManager.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/14/25.
//

import MediaServices
import Combine
import JellyfinAPI

final class MockJellyfinServiceManager: JellyfinServiceManagerProtocol {
    var loginShouldSucceed = true
    func attemptLogin(serverUrlString: String, userName: String, password: String) {
        isLoggedIn = loginShouldSucceed
    }
    
    @Published var jellyfinClient: JellyfinAPI.JellyfinClient?
    
    var jellyfinClientPublisher: Published<JellyfinAPI.JellyfinClient?>.Publisher {
        $jellyfinClient
    }
    
    @Published var isLoggedIn: Bool?
    
    var isLoggedInPublisher: Published<Bool?>.Publisher {
        $isLoggedIn
    }
    
    @Published var accessToken: String?
    
    var accessTokenPublisher: Published<String?>.Publisher {
        $accessToken
    }
    
    
}
