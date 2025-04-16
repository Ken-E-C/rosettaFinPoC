//
//  JellyfinDataBlob.swift
//  DataModels
//
//  Created by Kenny Cabral on 4/11/25.
//

import SwiftData

@Model
public class JellyfinDataBlob {
    public var serverUrl: String
    public var credentials: [JellyfinCredentials]
    
    public init(serverUrl: String, credentials: [JellyfinCredentials]) {
        self.serverUrl = serverUrl
        self.credentials = credentials
    }
    
    public func getCredentials(for user: String) -> JellyfinCredentials? {
        return credentials.first(where: { $0.userName == user})
    }
}
