//
//  HomeView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Kingfisher
import SwiftUI

/// Image feed view
/// Displays curated contents based on the user preferences
struct HomeView: View {
    let columns: [GridItem] = [.init(.flexible())]
    @State private var viewModel = HomeViewModel(keywords: [
        "Travel", "Cities", "Nature",
    ])  // TODO: - recieve from user preferences

    var body: some View {
        NavigationStack {
            // Display views based on viewmodel view state
            switch self.viewModel.viewState {
            case .Loading, nil:
                ProgressView()
            case .Failure(_):
                ErrorView {
                    // onReload action
                    Task {
                        self.viewModel.reset()
                        await self.viewModel.getImages(initial: true)
                    }
                }
            case _:
                HomeScrollView(viewModel: self.viewModel, columns: self.columns)
            }
        }
    }
}

/// Scroll view displaying the images in the homeview
///
/// Attempts a pinterest like appraoch, currently achieved by using two grid views with one flexible column each
struct HomeScrollView: View {
    let viewModel: HomeViewModel
    let columns: [GridItem]

    var body: some View {
        ZStack {  // zstack solely for the purpose of progressview approach using if statement
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top) {
                    // MARK: Grids
                    ImageGrid(
                        viewModel: self.viewModel, columns: self.columns,
                        images: self.viewModel.firstHalfImages)
                    ImageGrid(
                        viewModel: self.viewModel, columns: self.columns,
                        images: self.viewModel.secondHalfImages)
                }
                .padding(.horizontal)
                //                .overlay(
                //                    alignment: .bottom,
                //                    content: {
                //                        if self.viewModel.viewState == .Fetching {
                //                            ProgressView()
                //                        }
                //                    }
                //                )
                if self.viewModel.viewState == .Fetching {
                    ProgressView()
                        .padding(50)
                }
            }
            .navigationTitle("Voyago")
            .refreshable {
                // even tho refreshable has its own async handler
                // placed logic inside another Task that way when view refreshes
                // and refreshable redraws (as well for its task being discarded)
                // my logic is in a seperate standalone task thats being awaited
                await Task {
                    self.viewModel.reset()
                    await self.viewModel.getImages(initial: false)
                }.value
            }
        }
    }
}

/// A single image vertical grid
struct ImageGrid: View {
    let viewModel: HomeViewModel
    let columns: [GridItem]
    let images: [VoyagoImage]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.images, id: \.id) {
                image in

                ImageCard(image: image)
                    .onAppear {
                        // whenever the last image is on the screen
                        // fetch more images
                        if self.viewModel.lastImage(
                            image: image)
                            && self.viewModel.viewState != .Fetching
                        {
                            Task {
                                await self.viewModel.getImages(initial: false)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    HomeView()
}
