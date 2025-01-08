//
//  HomeView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
    let columns: [GridItem] = [.init(.flexible())]
    @State private var viewModel = HomeViewModel(keywords: [
        "Travel", "Cities", "Nature",
    ])

    var body: some View {
        NavigationStack {
            switch self.viewModel.viewState {
            case .Loading, nil:
                ProgressView()
            case .Failure:
                // TODO: - Error view
                Text("Error Encountered.")
            case _:
                HomeScrollView(viewModel: self.viewModel, columns: self.columns)
            }
        }
    }
}

struct HomeScrollView: View {
    let viewModel: HomeViewModel
    let columns: [GridItem]

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top) {
                    // MARK: Grids
                    ImageGrid(
                        viewModel: self.viewModel, columns: self.columns,
                        imageUrls: self.viewModel.firstHalfImageUrls)
                    ImageGrid(
                        viewModel: self.viewModel, columns: self.columns,
                        imageUrls: self.viewModel.secondHalfImageUrls)
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
                await Task {
                    viewModel.reset()
                    await self.viewModel.getMoreImages()
                }.value
            }
        }
    }
}

struct ImageGrid: View {
    let viewModel: HomeViewModel
    let columns: [GridItem]
    let imageUrls: [String]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.imageUrls, id: \.self) {
                imageUrl in

                // TODO: - PASS METADATA
                ImageCard(imageUrl: imageUrl)
                    .onAppear {
                        if self.viewModel.lastImage(
                            imageUrl: imageUrl)
                            && self.viewModel.viewState != .Fetching
                        {
                            Task {
                                await self.viewModel.getMoreImages()
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
