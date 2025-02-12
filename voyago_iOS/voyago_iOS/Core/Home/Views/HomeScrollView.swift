//
//  HomeScrollView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

/// Scroll view displaying the images in the homeview
///
/// Attempts a pinterest like appraoch, currently achieved by using two grid views with one flexible column each
struct HomeScrollView: View {
    let viewModel: HomeViewModel
    let columns: [GridItem] = [.init(.flexible())]

    var body: some View {
        ZStack {  // zstack solely for the purpose of progressview approach using if statement
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top) {
                    // MARK: Grids
                    VoyagoHomeImageGrid(
                        viewModel: self.viewModel,
                        images: self.viewModel.firstHalfImages,
                        columns: self.columns
                    )
                    VoyagoHomeImageGrid(
                        viewModel: self.viewModel,
                        images: self.viewModel.secondHalfImages,
                        columns: self.columns
                    )
                }
                .padding(.horizontal)
                //                if self.viewModel.viewState == .Fetching {
                //                    ProgressView()
                //                        .padding(50)
                //                }
            }
            .navigationTitle("voyago")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                // even tho refreshable has its own async handler
                // placed logic inside another Task that way when view refreshes
                // and refreshable redraws (as well for its task being discarded)
                // my logic is in a seperate standalone task thats being awaited
                await Task {
                    await viewModel.reload(initial: false)
                }.value
            }
        }
    }
}
