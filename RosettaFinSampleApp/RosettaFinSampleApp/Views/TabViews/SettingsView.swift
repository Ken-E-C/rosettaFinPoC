//
//  SettingsView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var showJellyFinSetupSheet: Bool = false
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                Button {
                    // Launch Modal for JellyFin Client Setup
                    showJellyFinSetupSheet.toggle()
                } label: {
                    HStack {
                        Text("JellyFin")
                        Spacer()
                    }
                    .padding()
                }
                Divider()
                    .background(Color.black)
                Button {
                    // Launch Modal for Spotify Client Setup
                } label: {
                    HStack {
                        Text("Spotify")
                        Spacer()
                    }
                    .padding()
                }
                Divider()
                    .background(Color.black)
                Button {
                    // Launch Modal for Tidal Client Setup
                } label: {
                    HStack {
                        Text("Tidal")
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5)
            .padding()
            .sheet(isPresented: $showJellyFinSetupSheet) {
                JellyfinSetupView()
            }
        }
    }
}
