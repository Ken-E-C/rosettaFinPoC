//
//  QueueData.swift
//  DataModels
//
//  Created by Kenny Cabral on 4/25/25.
//

import Foundation
import SwiftData

@Model
public class QueueData {
    public var enqueuedSongs: [MusicInfo]
    
    public init(enqueuedSongs: [MusicInfo]) {
        self.enqueuedSongs = enqueuedSongs
    }
    
    @discardableResult
    public func replaceQueue(with newQueue: [MusicInfo]) -> Bool {
        enqueuedSongs = newQueue
        return true
    }
}
