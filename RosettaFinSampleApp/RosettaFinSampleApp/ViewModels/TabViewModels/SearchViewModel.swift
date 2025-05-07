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
    
    struct ListItemInfo {
        var isSelected: Bool
        let musicInfo: MusicInfo
    }
    @Published var searchResults = [ListItemInfo]()
    var selectedSongs = [MusicInfo]()
    @Published var searchText = ""
    
    var mediaServices: MediaServices
    var storageServices: StorageServices
    var cancellables = Set<AnyCancellable>()
    
    init(mediaServices: MediaServices? = nil, storageServices: StorageServices? = nil) {
        self.mediaServices = mediaServices ?? MediaServices.shared
        self.storageServices = storageServices ?? StorageServices.shared
        loadSelectedSongs()
        setupSearchListener(using: $searchText)
    }
    
    private func loadSelectedSongs() {
        guard let queuedSongsDict = storageServices.massStorageManager.loadQueue()?.enqueuedSongs else {
            print("Warning: No songs found in persistent storage")
            return
        }
        selectedSongs = queuedSongsDict
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
                updateSearchResults(with: musicResults)
            }
            
        } catch {
            print("Error searching for songs using keyword \(keyword)")
        }
    }
    
    private func updateSearchResults(with newResults: [MusicInfo]) {
        var newResultsToReturn = [ListItemInfo]()
        for result in newResults {
            let isSelected = hasBeenSelected(result)
            let newSongInfo = ListItemInfo(isSelected: isSelected, musicInfo: result)
            newResultsToReturn.append(newSongInfo)
        }
        searchResults = newResultsToReturn
    }
    
    func didSelect(_ info: ListItemInfo) {
        if let index = searchResults.firstIndex(where: { $0.musicInfo.id == info.musicInfo.id } ) {
            searchResults[index].isSelected.toggle()
            
            switch searchResults[index].isSelected {
            case true:
                selectedSongs.append(info.musicInfo)
            case false:
                selectedSongs.removeAll(where: { $0.id == info.musicInfo.id })
            }
            storageServices.massStorageManager.replaceQueue(with: selectedSongs)
        }
    }
    
    private func hasBeenSelected(_ info: MusicInfo) -> Bool {
        return selectedSongs.contains(where: { $0.id == info.id})
    }
}
