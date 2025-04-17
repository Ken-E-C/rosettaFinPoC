// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftData

@Model
public class JellyfinCredentials: Codable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        case userName
        case password
        case accessToken
    }
    
    public var userName: String
    public var password: String
    public var accessToken: String?
    
    public init(userName: String, password: String, accessToken: String?) {
        self.userName = userName
        self.password = password
        self.accessToken = accessToken
    }
    
    // MARK: - Conformance BS
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.password = try container.decode(String.self, forKey: .password)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.password, forKey: .password)
        try container.encodeIfPresent(self.accessToken, forKey: .accessToken)
    }
    
    public static func == (lhs: JellyfinCredentials, rhs: JellyfinCredentials) -> Bool {
        lhs.userName == rhs.userName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(userName)
    }
}

