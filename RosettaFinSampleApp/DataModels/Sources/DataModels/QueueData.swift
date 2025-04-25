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
    public var enqueuedSongs: [MusicInfo.ID: MusicInfo]
    
    public init(enqueuedSongs: [MusicInfo.ID : MusicInfo]) {
        self.enqueuedSongs = enqueuedSongs
    }
    
    @discardableResult
    public func replaceQueue(with newQueue: [MusicInfo]) -> Bool {
        var updatedQueue = [MusicInfo.ID: MusicInfo]()
        
        for item in newQueue {
            updatedQueue[item.id] = item
        }
        enqueuedSongs = updatedQueue
        return true
    }
}
