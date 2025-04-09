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
        with password: String
    ) {
        print("JellyfinSetupViewModel: serverUrl = \(serverUrl)")
        print("JellyfinSetupViewModel: UserName = \(userName)")
        print("JellyfinSetupViewModel: password = \(password)")
        isLoggedIn.toggle()
    }
}
