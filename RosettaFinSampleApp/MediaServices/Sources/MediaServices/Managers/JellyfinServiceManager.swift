//
//  JellyfinLoginManager.swift
//  MediaServices
//
//  Created by Kenny Cabral on 4/10/25.
//

import Foundation
import Combine
import JellyfinAPI
import DataModels

@MainActor
public protocol JellyfinServiceManagerProtocol {
    var jellyfinClient: JellyfinClient? { get }
    var jellyfinClientPublisher: Published<JellyfinClient?>.Publisher { get }
    
    var isLoggedIn: Bool? { set get }
    var isLoggedInPublisher: Published<Bool?>.Publisher { get }
    
    var accessToken: String? { set get }
    var accessTokenPublisher: Published<String?>.Publisher { get }
    
    var serverUrl: String? { set get }
    var serverUrlPublisher: Published<String?>.Publisher { get }
    
    var currentUser: UserDto? { set get }
    var currentUserPublisher: Published<UserDto?>.Publisher { get }
    
    func attemptLogin(
        serverUrlString: String,
        userName: String,
        password: String,
        callback: @escaping (String?, JellyfinAPI.UserDto?, JellyfinServiceManager.JellyfinServiceError?) -> Void
    )
    
    func attemptLogout(callback: @escaping (Bool) -> Void)
    func search(for type: MediaServices.MediaType,
                       using keyword: String,
                       userId: String) async throws -> [MusicInfo]
    
    func getStreamingUrl(for item: MusicInfo) -> URL?
}

@MainActor
public final class JellyfinServiceManager: JellyfinServiceManagerProtocol, ObservableObject {
    
    public enum JellyfinServiceError: Error {
        case loginFailedOnServerSide
    }
    
    @Published public private(set) var jellyfinClient: JellyfinClient?
    public var jellyfinClientPublisher: Published<JellyfinClient?>.Publisher {
        $jellyfinClient
    }
    
    @Published public var isLoggedIn: Bool? = false
    public var isLoggedInPublisher: Published<Bool?>.Publisher {
        $isLoggedIn
    }
    
    @Published public var accessToken: String? = nil
    public var accessTokenPublisher: Published<String?>.Publisher {
        $accessToken
    }
    
    @Published public var currentUser: UserDto? = nil
    public var currentUserPublisher: Published<UserDto?>.Publisher {
        $currentUser
    }
    
    @Published public var serverUrl: String? = nil
    public var serverUrlPublisher: Published<String?>.Publisher {
        $serverUrl
    }
    
    init(isLoggedIn: Bool = false) {
        self.isLoggedIn = isLoggedIn
    }
    
    public func setupJellyfinClient(
        with urlString: String,
        using token: String? = nil
    ) {
        guard let url = URL(string: urlString) else {
            print("JellyfinServiceManager: Error: No valid URL found when one was expected")
            return
        }
        let config = JellyfinClient.Configuration(
            url: url,
            client: "RosettaFin",
            deviceName: "RosettaFinDevice",
            deviceID: "RosettaFin Id",
            version: "0.0.1")
        jellyfinClient = JellyfinClient(configuration: config, accessToken: token)
        accessToken = jellyfinClient?.accessToken
        serverUrl = urlString
        isLoggedIn = accessToken != nil
    }
    
    public func attemptLogin(
        serverUrlString: String,
        userName: String,
        password: String,
        callback: @escaping (String?, UserDto? ,JellyfinServiceError?) -> Void
    ) {
        print("JellyfinServiceManager: serverUrl = \(serverUrlString)")
        print("JellyfinServiceManager: UserName = \(userName)")
        print("JellyfinServiceManager: password = \(password)")
        guard let serverUrl = URL(string: serverUrlString) else {
            print("Error: could not parse URl from \(serverUrlString)")
            return
        }
        
        if jellyfinClient == nil || jellyfinClient?.configuration.url == serverUrl {
            setupJellyfinClient(with: serverUrlString)
        }
        guard let client = jellyfinClient else {
            print("Error: JellyfinClient was nil when a non nil value was expected")
            return
        }
        
        self.isLoggedIn = nil
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                let result = try await client.signIn(username: userName, password: password)
                if let retrievedToken = result.accessToken, let userData = result.user {
                    let token = retrievedToken
                    let user = userData
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.accessToken = token
                        self.isLoggedIn = true
                        self.currentUser = user
                        self.serverUrl = serverUrlString
                        callback(self.accessToken, self.currentUser, nil)
                    }
                }
            } catch {
                print("Error returned by server \(error)")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoggedIn = false
                    
                    callback(nil, nil, .loginFailedOnServerSide)
                }
            }
        }
    }
    
    public func attemptLogout(callback: @escaping (Bool) -> Void) {
        guard let jellyfinClient else {
            print("Error: No JellyfinClient has been setup. Cancelling Logout attempt.")
            callback(false)
            return
        }
        
        guard accessToken != nil else {
            print("Warning: no accessToken was found. Cancelling logout")
            callback(false)
            return
        }

        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                try await jellyfinClient.signOut()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoggedIn = false
                    self.accessToken = nil
                    self.currentUser = nil
                    callback(true)
                }
            } catch (let error) {
                print("Error: Unable to sign out \(error)")
                await MainActor.run {
                    callback(false)
                }
            }
        }
    }
    
    public func search(for type: MediaServices.MediaType,
                       using keyword: String,
                       userId: String) async throws -> [MusicInfo] {
        guard let jellyfinClient else {
            print("Error: Jellyfin Client not initialized")
            return []
        }
        var parameters = Paths.GetItemsByUserIDParameters()
        parameters.enableUserData = true
        parameters.fields = ItemFields.MinimumFields
        parameters.includeItemTypes = [.audio]
        parameters.isRecursive = true
        parameters.limit = 20
        parameters.searchTerm = keyword
        parameters.sortBy = [ItemSortBy.name.rawValue]
        parameters.sortOrder = [JellyfinAPI.SortOrder.ascending]
        
        let request = Paths.getItemsByUserID(userID: userId, parameters: parameters)
        let response = try await jellyfinClient.send(request)
        return translateToMusicInfo(jellyfinData: response.value.items)
    }
    
    private func translateToMusicInfo(jellyfinData: [BaseItemDto]?) -> [MusicInfo] {
        guard let jellyfinData else {
            print("Warning: no data retrieved from jellyfin search query")
            return[]
        }
        var musicInfoItems = [MusicInfo]()
        for dataItem in jellyfinData {
            if let songId = dataItem.id {
                let codec = dataItem.mediaSources?.first?.mediaStreams?.first(where: { $0.type == .audio })?.codec
                let container = dataItem.mediaSources?.first?.container
                let newMusicInfo = MusicInfo(
                    name: dataItem.name ?? "No Name",
                    artist: dataItem.albumArtist ?? "No Artist",
                    songId: songId,
                    imageTags: dataItem.imageTags ?? [:],
                    codec: codec,
                    container: container)
                musicInfoItems.append(newMusicInfo)
            }
        }
        return musicInfoItems
    }
    
    public func getStreamingUrl(for item: MusicInfo) -> URL? {
        guard let accessToken, let serverUrl else {
            print("Error: Missing server or accessToken for getting streaming url.")
            return nil
        }
        let codec = item.codec ?? "mp3"
        let container = item.container ?? "mp3"
        var components = URLComponents(string: "\(serverUrl)/Audio/\(item.songId)/universal")
            components?.queryItems = [
                URLQueryItem(name: "Container", value: container),
                URLQueryItem(name: "AudioCodec", value: codec),
                URLQueryItem(name: "DirectStream", value: "false"),
//                URLQueryItem(name: "MaxBitrate", value: "320000"),
                URLQueryItem(name: "api_key", value: accessToken)
            ]
        return components?.url
    }
    
    public func getArtworkUrl(for item: MusicInfo) -> URL? {
        guard let accessToken, let serverUrl else {
            print("Error: Missing server or accessToken for getting artwork url.")
            return nil
        }
        guard let tag = item.imageTags["Primary"] else {
            print("Warning: No Primary Image Tags were found.")
            return nil
        }
        
        var components = URLComponents(string: "\(serverUrl)/Items/\(item.songId)/Images/Primary")
        components?.queryItems = [
            URLQueryItem(name: "tag", value: tag),
            URLQueryItem(name: "api_key", value: accessToken)
            
        ]
        return components?.url
    }
}

fileprivate extension ItemFields {

    /// The minimum cases to use when retrieving an item or items
    /// for basic presentation. Depending on the context, using
    /// more fields and including user data may also be necessary.
    static let MinimumFields: [ItemFields] = [
        .mediaSources,
        .overview,
        .parentID,
        .taglines,
    ]
}
