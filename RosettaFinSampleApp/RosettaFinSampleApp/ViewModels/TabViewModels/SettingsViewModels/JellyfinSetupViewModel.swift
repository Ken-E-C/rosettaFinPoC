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
    @Published var isLoggedIn = false
    @Published var accessToken: String? = nil
    
    let loginManager: JellyfinLoginManager
    
    var cancellables = Set<AnyCancellable>()
    
    init(givenLoginManager: JellyfinLoginManager? = nil) {
        self.loginManager = givenLoginManager ?? MediaServices.shared.jellyfinLoginManager
        setupLoginListener(using: loginManager.$isLoggedIn)
    }
    
    private func setupLoginListener(using listenerPublisher: Published<Bool>.Publisher) {
        listenerPublisher.receive(on: DispatchQueue.main).sink { newLoginValue in
            self.isLoggedIn = newLoginValue
        }.store(in: &cancellables)
    }
    
    func attemptLogin(
        to serverUrl: String,
        for userName: String,
        with password: String,
        // storageManager: MassStorageManager
    ) {
        if !loginManager.isLoggedIn {
            loginManager.attemptLogin(
                serverUrl: serverUrl,
                userName: userName,
                password: password)
        }
    }
}
