// The Swift Programming Language
// https://docs.swift.org/swift-book


import Combine
import SwiftData
import DataModels
import Foundation

@MainActor
public class MassStorageManager {
    
    var container: ModelContainer?
    
    public init(container: ModelContainer? = nil) {
        do {
            self.container = try ModelContainer(for: JellyfinDataBlob.self)
        } catch {
            print("Error: Unable to initialize SwiftData container in MassStorageManager")
        }
    }
    
    public func saveJellyfinLogin(
        on serverUrlString: String,
        for userName: String,
        password: String,
        token accessToken: String
    ) {
            
        let descriptor = FetchDescriptor<JellyfinDataBlob>(
            predicate: #Predicate { $0.serverUrl == serverUrlString },
            sortBy: [.init(\.serverUrl, order: .forward)]
        )
        
        if let serverDataBlob = fetchJellyfinServerInfo(using: descriptor) {
            if serverDataBlob.updateToken(for: userName, with: accessToken) {
                saveContext()
            } else {
                print("Error saving updated token info for user \(userName)")
            }
        } else {
            print("WARNING: No saved data found for \(serverUrlString). Creating new entry.")
            let newCreds = JellyfinCredentials(userName: userName, password: password, accessToken: accessToken)
            let newDataBlob = JellyfinDataBlob(serverUrl: serverUrlString, credentials: [newCreds])
            addServerData(using: newDataBlob)
            saveContext()
        }
    }
    
    private func addServerData(using dataBlob: JellyfinDataBlob) {
        guard let container else {
            print("Error: ModelContainer not initialized")
            return
        }
        container.mainContext.insert(dataBlob)
    }
    
    private func fetchJellyfinServerInfo(using descriptor: FetchDescriptor<JellyfinDataBlob>) -> JellyfinDataBlob? {
        guard let container else {
            print("Error: ModelContainer not initialized")
            return nil
        }
        
        do {
            return try container.mainContext.fetch(descriptor).first
        } catch {
            print("Error fetching data with the following descriptor: \(descriptor)")
            return nil
        }
    }
    
    
    
    private func saveContext() {
        guard let container else {
            print("Error: ModelContainer not initialized")
            return
        }
        do {
            try container.mainContext.save()
        } catch {
            print("Error saving mainContext")
        }
    }
}
