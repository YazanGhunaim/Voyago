//
//  VoyagoHomeImageGrid.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

/// A single image vertical grid
struct VoyagoHomeImageGrid: View {
    let viewModel: HomeViewModel
    let images: [VoyagoImage]
    let columns: [GridItem]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.images, id: \.id) {
                image in
                VoyagoHomeImageCard(image: image)
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
