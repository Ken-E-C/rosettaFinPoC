//
//  ContentView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Now Playing", systemImage: "music.quarternote.3") {
                NowPlayingView()
            }
            Tab("Queue", systemImage: "music.note.list") {
                QueueView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
