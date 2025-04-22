//
//  JellyfinSetupViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import Foundation
import Combine
import MediaServices
import StorageServices

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
    
    @Published var startingServerUrl: String = ""
    @Published var startingUsername: String = ""
    
    let serviceManager: JellyfinServiceManagerProtocol
    let storageManager: MassStorageManager
    
    var cancellables = Set<AnyCancellable>()
    
    init(givenServiceManager: JellyfinServiceManagerProtocol? = nil,
         givenStorageManager: MassStorageManager? = nil) {
        self.serviceManager = givenServiceManager ?? MediaServices.shared.jellyfinManager
        self.storageManager = givenStorageManager ?? StorageServices.shared.massStorageManager
        populateLoginFields(using: storageManager, with: serviceManager.accessToken)
        setupLoginListener(using: serviceManager.isLoggedInPublisher)
    }
    
    private func populateLoginFields(using storageManager: MassStorageManager, with token: String?) {
        guard let currentServerData = storageManager.fetchLastUsedServerData() else {
            print("Warning: no server data was found. leaving fields blank")
            return
        }
        startingServerUrl = currentServerData.serverUrl
        
        guard let currentUser = currentServerData.getLastUser() else {
            print("Warning: no user data was found for \(startingServerUrl). leaving user field blank")
            return
        }
        startingUsername = currentUser.userName
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
        with password: String
    ) {
        guard let isLoggedIn = serviceManager.isLoggedIn else {
            print("JellyfinSetupViewModel: Warning: Login in Progress")
            return
        }
        if !isLoggedIn {
            serviceManager.attemptLogin(
                serverUrlString: serverUrl,
                userName: userName,
                password: password) { [weak self] accessToken, error in
                    guard let self else { return }
                    if let error {
                        print("Error returned from login attempt: \(error)")
                        return
                    }
                    
                    if let accessToken {
                        self.storageManager.saveJellyfinLogin(
                            on: serverUrl,
                            for: userName,
                            password: password,
                            token: accessToken,
                            accessDate: Date.now)
                        return
                    }
                    print("WARNING: Login returned with no token or error thrown")
                }
        }
    }
}
