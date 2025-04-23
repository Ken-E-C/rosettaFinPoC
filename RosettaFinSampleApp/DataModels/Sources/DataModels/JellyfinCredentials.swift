// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftData

@Model
public class JellyfinCredentials: Codable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        case userName
        case userId
        case password
        case accessToken
        case lastUsed
    }
    
    public var userName: String
    public var userId: String
    public var password: String
    public var accessToken: String?
    public var lastUsed: Date?
    
    public init(userName: String, userId: String, password: String, accessToken: String?, lastUsed: Date?) {
        self.userName = userName
        self.userId = userId
        self.password = password
        self.accessToken = accessToken
        self.lastUsed = lastUsed
    }
    
    // MARK: - Conformance BS
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.password = try container.decode(String.self, forKey: .password)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.lastUsed = try container.decodeIfPresent(Date.self, forKey: .lastUsed)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.password, forKey: .password)
        try container.encodeIfPresent(self.accessToken, forKey: .accessToken)
        try container.encodeIfPresent(self.lastUsed, forKey: .lastUsed)
    }
    
    public static func == (lhs: JellyfinCredentials, rhs: JellyfinCredentials) -> Bool {
        lhs.userName == rhs.userName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(userName)
    }
}

