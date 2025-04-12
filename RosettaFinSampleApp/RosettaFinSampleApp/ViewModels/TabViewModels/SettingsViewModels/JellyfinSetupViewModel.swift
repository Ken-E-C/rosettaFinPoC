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
    
    let serviceManager: JellyfinServiceManager
    
    var cancellables = Set<AnyCancellable>()
    
    init(givenServiceManager: JellyfinServiceManager? = nil) {
        self.serviceManager = givenServiceManager ?? MediaServices.shared.jellyfinManager
        setupLoginListener(using: serviceManager.$isLoggedIn)
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
        guard let isLoggedIn = serviceManager.isLoggedIn else {
            print("JellyfinSetupViewModel: Warning: Login in Progress")
            return
        }
        if !isLoggedIn {
            serviceManager.attemptLogin(
                serverUrlString: serverUrl,
                userName: userName,
                password: password)
        }
    }
}
