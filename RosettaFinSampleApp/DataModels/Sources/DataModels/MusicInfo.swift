//
//  MusicInfo.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

public struct MusicInfo: Identifiable, Sendable, Equatable, Codable {
    public var id: String {
        name + artist
    }
    
    public let name: String
    public let artist: String
    
    public init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
    
    public static func == (lhs: MusicInfo, rhs: MusicInfo) -> Bool {
        lhs.id == rhs.id
    }
}
