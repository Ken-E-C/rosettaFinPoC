//
//  JellyfinDataBlob.swift
//  DataModels
//
//  Created by Kenny Cabral on 4/11/25.
//

import Foundation
import SwiftData

@Model
public class JellyfinDataBlob {
    public var serverUrl: String
    public var credentials: Set<JellyfinCredentials>
    
    public init(serverUrl: String, credentials: Set<JellyfinCredentials>) {
        self.serverUrl = serverUrl
        self.credentials = credentials
    }
    
    public func updateToken(for user: String, with token: String) -> Bool {
        guard let currentCred = credentials.first(where: { $0.userName == user }) else {
            print("WARNING: No credentials found for user \(user)")
            return false
        }
        currentCred.accessToken = token
        return true
    }
}
