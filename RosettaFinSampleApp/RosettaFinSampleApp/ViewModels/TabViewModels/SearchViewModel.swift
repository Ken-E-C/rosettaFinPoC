//
//  SearchViewModel.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/8/25.
//

import Foundation
import Combine
import MediaServices
import StorageServices
import DataModels

@MainActor
class SearchViewModel: ObservableObject {
    @Published var enqueuedSongs = [MusicInfo]()
    @Published var searchText = ""
    
    var mediaServices: MediaServices
    var storageServices: StorageServices
    var cancellables = Set<AnyCancellable>()
    
    init(mediaServices: MediaServices? = nil, storageServices: StorageServices? = nil) {
        self.mediaServices = mediaServices ?? MediaServices.shared
        self.storageServices = storageServices ?? StorageServices.shared
        setupMockSongs()
        setupSearchListener(using: $searchText)
    }
    
    private func setupMockSongs() {
        enqueuedSongs = [
            MusicInfo(name: "Bohemian Rhapsody", artist: "Queen"),
            MusicInfo(name: "Imagine", artist: "John Lennon"),
            MusicInfo(name: "Never Gonna Give You Up", artist: "Rick Astley"),
            MusicInfo(name: "Hey Jude", artist: "The Beatles"),
        ]
    }
    
    private func setupSearchListener(using publisher: Published<String>.Publisher) {
        publisher
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] newSearchTerm in
                guard let self else { return }
                self.search(for: newSearchTerm)
            }.store(in: &cancellables)
    }
    
    func search(for keyword: String) {
        do {
            guard let userId = storageServices.massStorageManager.fetchLastUsedServerData()?.getLastUser()?.userId else {
                print("Error: Unable to obtain userId")
                return
            }
            try mediaServices.search(for: .music, using: keyword, userId: userId) { [weak self] musicResults in
                guard let self else { return }
                self.enqueuedSongs = musicResults
            }
            
        } catch {
            print("Error searching for songs using keyword \(keyword)")
        }
    }
}
