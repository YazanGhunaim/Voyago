//
//  TravelBoardsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import SwiftUI

// TODO: Cache travel boards [ model conversion to swiftdata ]
struct TravelBoardsView: View {
    @State private var viewModel = TravelBoardsViewModel()
    @State private var showingSheet = false
    @State private var showingAlert = false

    @Environment(GenTravelBoardFormViewModel.self) private var genFormViewModel

    var body: some View {
        NavigationStack {
            switch viewModel.viewState {
            case .Loading, nil:
                ProgressView()
            case .Failure(_):
                ErrorView {
                    Task {
                        await self.viewModel.getUserTravelBoards(initial: true)
                    }
                }
            case _:
                switch genFormViewModel.viewState {
                case .Success, nil:
                    TravelBoardsScrollView(
                        viewModel: viewModel, showingSheet: $showingSheet
                    )
                    .task {
                        await viewModel.getUserTravelBoards()
                    }
                case .Loading:
                    VisualizingProgressView()
                case .Failure(_):
                    EmptyView()  // TODO: Alert
                }
            }
        }
    }
}

#Preview {
    TravelBoardsView()
}
