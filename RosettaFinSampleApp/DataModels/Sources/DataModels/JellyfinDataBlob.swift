//
//  JellyfinDataBlob.swift
//  DataModels
//
//  Created by Kenny Cabral on 4/11/25.
//

public struct JellyfinDataBlob {
    public let serverUrl: String
    public var credentials: [JellyfinCredentials]
    
    public init(serverUrl: String, credentials: [JellyfinCredentials]) {
        self.serverUrl = serverUrl
        self.credentials = credentials
    }
}
