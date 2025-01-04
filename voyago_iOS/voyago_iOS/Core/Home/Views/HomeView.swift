//
//  HomeView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel(keywords: [
        "Travel", "Cities", "Nature", "Tourism",
    ])
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            switch self.viewModel.viewState {
            case .Loading:
                ProgressView()
            case .Failure:
                // TODO: Error view
                Text("Error Encountered.")
            case _:
                HomeScrollView(viewModel: self.viewModel, columns: self.columns)
            }
        }
    }
}

#Preview {
    HomeView()
}

struct HomeScrollView: View {
    let viewModel: HomeViewModel
    let columns: [GridItem]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(self.viewModel.imageUrls, id: \.self) {
                    imageUrl in

                    // TODO: PASS METADATA
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
            .overlay(
                alignment: .bottom,
                content: {
                    if self.viewModel.viewState == .Fetching {
                        ProgressView()
                    }
                }
            )
            .padding(.horizontal)
        }
        .navigationTitle("Voyago")
    }
}
