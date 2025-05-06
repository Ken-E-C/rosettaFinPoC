//
//  MusicInfo.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//
import Foundation

public struct MusicInfo: Identifiable, Sendable, Equatable, Codable {
    public var id: String {
        name + artist
    }
    
    public let name: String
    public let artist: String
    public let songId: String
    public let imageTags: [String : String]
    public let codec: String?
    public let container: String?
    public let streamingUrl: URL?
    public let artworkUrl: URL?
    
    public init(
        name: String,
        artist: String,
        songId: String,
        imageTags: [String : String],
        codec: String?,
        container: String?,
        streamingUrl: URL?,
        artworkUrl: URL?
    ) {
        self.name = name
        self.artist = artist
        self.songId = songId
        self.imageTags = imageTags
        self.codec = codec
        self.container = container
        self.streamingUrl = streamingUrl
        self.artworkUrl = artworkUrl
    }
    
    public static func == (lhs: MusicInfo, rhs: MusicInfo) -> Bool {
        lhs.id == rhs.id
    }
}
