//
//  VisualizeTravelBoardView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

struct VisualizeTravelBoardView: View {
    @State private var path = NavigationPath()
    @State private var viewModel = VisualizeTravelBoardViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.viewState {
                case .none:
                    VisualizeTravelBoardFormView(viewModel: viewModel)
                case .Success:
                    TravelBoardDetailsView(travelBoard: viewModel.visualizedBoard!, toggleTabbar: false)
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
