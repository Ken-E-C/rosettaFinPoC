//
//  BuildQueueViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 5/12/25.
//

import Foundation
import Combine
import DataModels
import StorageServices
import MediaServices
import AIServices

final class BuildQueueViewModel: ObservableObject {
    @Published var newPlaylist: [MusicInfo]
    
    let mediaServices: MediaServices
    let storageServices: StorageServices
    
    init(mediaServices: MediaServices?, storageServices: StorageServices? = nil) {
        self.mediaServices = mediaServices ?? MediaServices.shared
        self.storageServices = storageServices ?? StorageServices.shared
    }
    
    func launchPlaylistCreationWorkflow(using prompt: String) {
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            self.createPlaylist(using: prompt)
        }
    }
    
    func createPlaylist(using prompt: String) async {
        if mediaServices.jellyfinManager.isLoggedIn {
            guard let serverData = storageServices.massStorageManager.fetchLastUsedServerData() else {
                print("Error: No server data found")
                return
            }
            guard let userId = serverData.getLastUser()?.userId else {
                print("Error: Unable to obtain userId")
                return
            }
            var generatedPlaylist = [MusicInfo]()
            // Get Library Metadata [(Artist, Song)]
            let libraryData = storageServices.massStorageManager.
            
            // Create prompt including library metadata
            let generatedPlaylistMetadata: [(String, String)] = await aiServices.generatePlaylist(from: prompt, constrainedBy: libraryData)
            
            // create playlist from metadata retrieved from AI backend
            do {
                for entry in generatedPlaylistMetadata {
                    let musicEntry = try await mediaServices.jellyfinManager.search(
                        for: .music,
                        using: entry.1,
                        userId: userId
                    )
                    generatedPlaylist += musicEntry
                }
            } catch {
                print("Error attempting to generate playlist")
            }
            
            // Publish results
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.newPlaylist = generatedPlaylist
            }
        }
    }
}
