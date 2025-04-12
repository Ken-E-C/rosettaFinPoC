//
//  RosettaFinSampleAppApp.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/7/25.
//

import SwiftUI
import MediaServices
import DataModels

@main
struct RosettaFinSampleAppApp: App {
    
    init() {
        setupServices()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func setupServices() {
        let dataBlob = JellyfinDataBlob(serverUrl: "https://media.krui.me", credentials: [
            JellyfinCredentials(
                userName: "Kennyfin",
                password: "77946548d8b~",
                accessToken: "39b16320-3283-4ee1-b1de-c3a47d38092d")
        ])
        
        MediaServices.shared.setupServices(with: dataBlob)
    }
}
