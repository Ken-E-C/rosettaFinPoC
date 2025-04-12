// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public struct JellyfinCredentials {
    public let userName: String
    public let password: String
    public let accessToken: String
    
    public init(userName: String, password: String, accessToken: String) {
        self.userName = userName
        self.password = password
        self.accessToken = accessToken
    }
}
