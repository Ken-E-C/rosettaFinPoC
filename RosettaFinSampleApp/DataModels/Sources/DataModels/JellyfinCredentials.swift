// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftData

@Model
public class JellyfinCredentials {
    public var userName: String
    public var password: String
    public var accessToken: String
    
    public init(userName: String, password: String, accessToken: String) {
        self.userName = userName
        self.password = password
        self.accessToken = accessToken
    }
}
