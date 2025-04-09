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
    
    @State var didLoginSucceed = false
    
    init(viewModel: JellyfinSetupViewModel = JellyfinSetupViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack(alignment: .leading) {
            TextBox(
                placeholderText: "ServerUrl...",
                inputText: $serverUrl)
            TextBox(
                placeholderText: "UserName...",
                inputText: $username)
            TextBox(
                placeholderText: "Password...",
                inputText: $password)
            buttonPanel
            Spacer()
        }
        .onReceive(viewModel.$isLoggedIn, perform: { newValue in
            didLoginSucceed = newValue
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
            Text("Did Login Succeed: \(didLoginSucceed)")
        }
    }
}
