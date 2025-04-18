//
//  RosettaFinSampleAppApp.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/7/25.
//

import SwiftUI
import MediaServices
import DataModels
import StorageServices

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
        if let lastUsedJellyfinServer = StorageServices.shared.massStorageManager.fetchLastUsedServerData() {
            MediaServices.shared.setupServices(with: lastUsedJellyfinServer)
        }
    }
}
