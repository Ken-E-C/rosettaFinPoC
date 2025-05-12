//
//  JellyfinLibraryCatalog.swift
//  DataModels
//
//  Created by Kenny Cabral on 5/12/25.
//

import Foundation
import SwiftData

@Model
public class JellyfinLibraryCatalog {
    public var serverUrl: String
    public var userName: String
    public var lastRefreshed: Date
    public var catalog: [MusicInfo]
    
    public init(
        serverUrl: String,
        userName: String,
        lastRefreshed: Date,
        catalog: [MusicInfo]
    ) {
        self.serverUrl = serverUrl
        self.userName = userName
        self.lastRefreshed = lastRefreshed
        self.catalog = catalog
    }
}
