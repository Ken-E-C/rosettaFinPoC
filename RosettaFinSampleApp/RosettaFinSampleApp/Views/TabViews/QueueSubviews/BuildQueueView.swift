//
//  BuildQueueView.swift
//  RosettaFinSampleApp
//
//  Created by Kenny Cabral on 5/12/25.
//

import SwiftUI

struct BuildQueueView: View {
    @StateObject var viewModel: BuildQueueViewModel
    @State var promptText = ""
    
    init(givenViewModel: BuildQueueViewModel? = nil, promptText: String = "") {
        let viewModel = givenViewModel ?? BuildQueueViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Spacer()
            InputTextSection
        }
    }
    
    var InputTextSection: some View {
        VStack {
            Spacer()
            FloatingBar {
                HStack {
                    TextField("What kind of playlist do you want...", text: $promptText)
                    Button {
                        // viewModel.launchPlaylistCreationWorkflow(using: promptText)
                    } label: {
                        Image(systemName: "bubble.left.and.bubble.right")
                    }
                }
            }
            .padding(.bottom, 20.0)
        }
    }
}
