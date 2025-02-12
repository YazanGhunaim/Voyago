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
    @State private var viewModel = HomeViewModel(keywords: [
        "Travel", "Cities", "Nature",
    ])  // TODO: - recieve from user preferences

    var body: some View {
        NavigationStack {
            switch viewModel.viewState {
            case .Loading, nil:
                ProgressView()
            case .Failure(_):
                ErrorView {
                    // onReload action
                    Task { await viewModel.reload(initial: true) }
                }
            case _:
                HomeScrollView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    HomeView()
}
