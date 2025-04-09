//
//  SongInfo.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

struct SongInfo: Identifiable {
    var id: String {
        name + artist
    }
    
    let name: String
    let artist: String
}
