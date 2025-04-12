//
//  JellyfinCreds.swift
//  MediaServices
//
//  Created by Kenny Cabral on 4/11/25.
//
import Foundation

public struct JellyfinCreds {
    public let userName: String
    public let password: String
    public let accessToken: String
    
    public init(userName: String, password: String, accessToken: String) {
        self.userName = userName
        self.password = password
        self.accessToken = accessToken
    }
}
