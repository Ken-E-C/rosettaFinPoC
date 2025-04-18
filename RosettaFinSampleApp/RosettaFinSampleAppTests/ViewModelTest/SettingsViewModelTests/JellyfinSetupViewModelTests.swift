//
//  JellyfinSetupViewModelTests.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/14/25.
//

import XCTest
import Combine
@testable import RosettaFinSampleApp

@MainActor
final class JellyfinSetupViewModelTests: XCTestCase {
    
    var sut: JellyfinSetupViewModel!
    var mockServiceManager: MockJellyfinServiceManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        mockServiceManager = MockJellyfinServiceManager()
        sut = JellyfinSetupViewModel(givenServiceManager: mockServiceManager)
        cancellables = Set<AnyCancellable>()
    }
    
    func testAttemptLogin_whenCalledWithoutError_succeeds() {
        mockServiceManager.isLoggedIn = false
        let expectation = XCTestExpectation(description: "Didn't login")
        sut.$isLoggedIn.dropFirst().sink { newState in
            if newState == .loggedIn {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        sut.attemptLogin(to: "bogus.server.com", for: "James Bond", with: "007")
        wait(for: [expectation])
    }
}
