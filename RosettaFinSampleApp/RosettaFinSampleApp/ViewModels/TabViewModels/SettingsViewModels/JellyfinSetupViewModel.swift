//
//  JellyfinSetupViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import Foundation
import Combine
import MediaServices

@MainActor
class JellyfinSetupViewModel: ObservableObject {
    
    enum LoginState {
        case undefined
        case authInProgress
        case loggedIn
        case loggedOut
    }
    
    @Published var isLoggedIn: LoginState = .authInProgress
    @Published var accessToken: String? = nil
    
    let loginManager: JellyfinLoginManager
    
    var cancellables = Set<AnyCancellable>()
    
    init(givenLoginManager: JellyfinLoginManager? = nil) {
        self.loginManager = givenLoginManager ?? MediaServices.shared.jellyfinLoginManager
        setupLoginListener(using: loginManager.$isLoggedIn)
    }
    
    private func setupLoginListener(using listenerPublisher: Published<Bool?>.Publisher) {
        listenerPublisher.receive(on: DispatchQueue.main).sink { newLoginValue in
            switch newLoginValue {
            case nil:
                self.isLoggedIn = .authInProgress
            case true:
                self.isLoggedIn = .loggedIn
            case false:
                self.isLoggedIn = .loggedOut
            default:
                // Should Never reach this state
                print("JellyfinSetupViewModel: Error: undefined login state detected")
                self.isLoggedIn = .undefined
            }
        }.store(in: &cancellables)
    }
    
    func attemptLogin(
        to serverUrl: String,
        for userName: String,
        with password: String,
        // storageManager: MassStorageManager
    ) {
        guard let isLoggedIn = loginManager.isLoggedIn else {
            print("JellyfinSetupViewModel: Warning: Login in Progress")
            return
        }
        if !isLoggedIn {
            loginManager.attemptLogin(
                serverUrl: serverUrl,
                userName: userName,
                password: password)
        }
    }
}
