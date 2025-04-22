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
            self.container = try ModelContainer(for: JellyfinDataBlob.self, JellyfinCredentials.self)
        } catch {
            print("Error: Unable to initialize SwiftData container in MassStorageManager")
        }
    }
    
    public func fetchLastUsedServerData() -> JellyfinDataBlob? {
        let descriptor = FetchDescriptor<JellyfinDataBlob>(
            sortBy: [SortDescriptor(\.lastAccessed, order: .reverse)]
        )
        
        guard let lastUsedServer = fetchJellyfinServerInfo(using: descriptor) else {
            print("WARNING: No Server data was found using descriptor \(descriptor).")
            return nil
        }
        
        return lastUsedServer
    }
    
    public func updateToken(for username: String, on serverUrlString: String, using accessToken: String?, accessDate: Date) -> Bool {
        let descriptor = FetchDescriptor<JellyfinDataBlob>(
            predicate: #Predicate { $0.serverUrl == serverUrlString },
            sortBy: [.init(\.serverUrl, order: .forward)]
        )
        
        if let serverDataBlob = fetchJellyfinServerInfo(using: descriptor) {
            if serverDataBlob.updateToken(for: username, with: accessToken, on: accessDate) {
                saveContext()
                return true
            } else {
                print("Warning: No user data found for \(username) in \(serverUrlString)")
            }
        } else {
            print("Warning: No Server data found for \(serverUrlString)")
        }
        return false
    }
    
    public func saveJellyfinUserInfo(
        on serverUrlString: String,
        for userName: String,
        password: String,
        token accessToken: String?,
        accessDate: Date
    ) {
            
        let descriptor = FetchDescriptor<JellyfinDataBlob>(
            predicate: #Predicate { $0.serverUrl == serverUrlString },
            sortBy: [.init(\.serverUrl, order: .forward)]
        )
        
        if let serverDataBlob = fetchJellyfinServerInfo(using: descriptor) {
            if serverDataBlob.updateToken(for: userName, with: accessToken, on: accessDate) {
                saveContext()
            } else {
                print("Attempting to create new user entry")
                guard let accessToken, serverDataBlob.addCredential(
                    for: userName,
                    with: password,
                    using: accessToken,
                    on: accessDate) else {
                    print("Error: unable to create new credential for user \(userName)")
                    return 
                }
            }
        } else {
            print("WARNING: No saved data found for \(serverUrlString). Creating new entry.")
            guard let accessToken else {
                print("Error: no accessToken found when one was expected")
                return
            }
            let newDataBlob = JellyfinDataBlob(serverUrl: serverUrlString, credentials: [])
            newDataBlob.addCredential(
                for: userName,
                with: password,
                using: accessToken,
                on: accessDate)
            
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
