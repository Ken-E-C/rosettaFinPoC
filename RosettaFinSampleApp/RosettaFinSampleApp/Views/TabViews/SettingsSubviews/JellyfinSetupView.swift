//
//  JellyfinSetupView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 4/9/25.
//

import SwiftUI

struct JellyfinSetupView: View {
    
    @StateObject var viewModel: JellyfinSetupViewModel
    
    @State var serverUrl = ""
    @State var username = ""
    @State var password = ""
    
    @State var loginStatus = ""
    
    init(givenViewModel: JellyfinSetupViewModel? = nil) {
        let viewModel = givenViewModel ??  JellyfinSetupViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack(alignment: .leading) {
            TextBox(
                placeholderText: "ServerUrl...",
                inputText: $serverUrl,
                disableAutocorrect: true)
            TextBox(
                placeholderText: "UserName...",
                inputText: $username,
                disableAutocorrect: true)
            TextBox(
                placeholderText: "Password...",
                inputText: $password,
                isSecure: true)
            buttonPanel
            Spacer()
        }
        .onReceive(viewModel.$isLoggedIn, perform: { newValue in
            switch newValue {
            case .authInProgress:
                loginStatus = "In Progress"
            case .loggedIn:
                loginStatus = "Logged In"
            case .loggedOut:
                loginStatus = "Logged Out"
            case .undefined:
                loginStatus = "Unknown"
            }
        })
        .onReceive(viewModel.$startingServerUrl, perform: { newServerUrl in
            serverUrl = newServerUrl
        })
        .onReceive(viewModel.$startingUsername, perform: { newUsername in
            username = newUsername
        })
        .padding(.top, 24.0)
        .padding(.horizontal)
    }
    
    var buttonPanel: some View {
        HStack {
            SimpleButton(title: "Login") {
                viewModel.attemptLogin(
                    to: serverUrl,
                    for: username,
                    with: password)
            }
            Spacer()
            Text("Login Status: \(loginStatus)")
        }
    }
}
