//
//  JellyfinSetupViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import Combine

class JellyfinSetupViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    func attemptLogin(
        to serverUrl: String,
        for userName: String,
        with password: String,
        loginManager: JellyfinLoginManager = MediaServices.shared.jellyfinLoginManager,
        storageManager: MassStorageManager = MassStorageManager.shared
    ) {
        print("JellyfinSetupViewModel: serverUrl = \(serverUrl)")
        print("JellyfinSetupViewModel: UserName = \(userName)")
        print("JellyfinSetupViewModel: password = \(password)")
        
        if !loginManager.isLoggedIn {
            loginManager.attemptLogin(
                serverUrl: serverUrl,
                userName: userName,
                password: password) { (didSucceed, tokenInfo ,error) in
                    if didSucceed {
                        guard let self else { return }
                        self.isLoggedIn = true
                        storageManager.saveUserInfo(for: userName, service: .jellyfin, tokenInfo)
                    }
                }
        }
    }
}
