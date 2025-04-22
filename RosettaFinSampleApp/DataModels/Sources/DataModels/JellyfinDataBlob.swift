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
    public var credentials: [JellyfinCredentials]
    public var lastAccessed: Date?
    
    public init(serverUrl: String, credentials: [JellyfinCredentials]) {
        self.serverUrl = serverUrl
        self.credentials = credentials
    }
    
    @discardableResult
    public func addCredential(
        for userName: String,
        with password: String,
        using accessToken: String,
        on accessDate: Date
    ) -> Bool {
        let newCreds = JellyfinCredentials(
            userName: userName,
            password: password,
            accessToken: accessToken,
            lastUsed: accessDate
        )
        if !credentials.contains(newCreds) {
            credentials.append(newCreds)
            lastAccessed = accessDate
            return true
        }
        print("Warning: Credential already exists. Please call updateToken() to update credentials.")
        return false
    }
    
    public func updateToken(for user: String, with token: String?, on accessDate: Date) -> Bool {
        guard let currentCredIndex = credentials.firstIndex(where: { $0.userName == user }) else {
            print("WARNING: No credentials found for user \(user)")
            return false
        }
        credentials[currentCredIndex].accessToken = token
        credentials[currentCredIndex].lastUsed = accessDate
        lastAccessed = accessDate
        return true
    }
    
    public func getLastUser() -> JellyfinCredentials? {
        return credentials.sorted(by: { ($0.lastUsed ?? .distantPast) > ($1.lastUsed ?? .distantPast) }).first
    }
}
