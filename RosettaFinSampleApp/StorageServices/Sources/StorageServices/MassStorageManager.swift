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
        token accessToken: String) {
            
            let descriptor = FetchDescriptor<JellyfinDataBlob>(
                predicate: #Predicate { $0.serverUrl == serverUrlString },
                sortBy: [.init(\.serverUrl, order: .forward)]
            )
            
            if let serverDataBlob = fetchJellyfinServerInfo(using: descriptor),
               let userInfo = serverDataBlob.getCredentials(for: userName) {
                userInfo.accessToken = accessToken
                container?.mainContext
            }
            
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
}
