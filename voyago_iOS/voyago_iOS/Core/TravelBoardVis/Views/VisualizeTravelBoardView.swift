//
//  VisualizeTravelBoardView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

struct VisualizeTravelBoardView: View {
    @State private var path = NavigationPath()

    @Environment(VisualizeTravelBoardViewModel.self) private var viewModel

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.viewState {
                case .none:
                    VisualizeTravelBoardFormView()
                case .Success:
                    TravelBoardDetailsView(travelBoard: viewModel.visualizedBoard!)
                case .Loading:
                    VisualizingProgressView()
                        .interactiveDismissDisabled()
                case .Failure(_):
                    ErrorView()
                }
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
