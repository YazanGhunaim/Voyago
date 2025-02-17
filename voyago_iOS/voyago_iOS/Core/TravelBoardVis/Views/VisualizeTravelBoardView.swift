//
//  VisualizeTravelBoardView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

// Form View for itinerary user input
struct VisualizeTravelBoardView: View {
    @State private var path = NavigationPath()

    @Environment(VisualizeTravelBoardViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            switch viewModel.viewState {
            case .Success, .none:
                VisualizeTravelBoardFormView()
            case .Loading:
                VisualizingProgressView()
                    .interactiveDismissDisabled()
            case .Failure(_):
                ErrorView()
            }
        }
        .onDisappear {
            viewModel.reset()
        }
    }
}

//#Preview {
//    VisualizeTravelBoardView()
//}
