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
                TravelBoardsScrollView(
                    viewModel: viewModel, showingSheet: $showingSheet
                )
            }
        }
    }
}

struct TravelBoardsScrollView: View {
    let viewModel: TravelBoardsViewModel
    @Binding var showingSheet: Bool

    var body: some View {
        ScrollView {
            if viewModel.travelBoards!.data.isEmpty {
                NoTravelBoardsView(showingSheet: $showingSheet)
            } else {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.travelBoards!.data, id: \.id) {
                        board in
                        TravelBoardCard(
                            recommendationQuery: RecommendationQuery(
                                destination: board.recommendationQuery!
                                    .destination,
                                days: board.recommendationQuery!.days
                            ),
                            image: board.destinationImage)
                    }
                }
            }
        }
        .navigationTitle("Travel boards")
        .refreshable {
            await Task {
                await viewModel.getUserTravelBoards()
            }.value
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        showingSheet.toggle()
                    },
                    label: {
                        Image(systemName: "plus")
                    }
                )
                .tint(.primary)
            }
        }
        .sheet(isPresented: $showingSheet) {
            GenTravelBoardFormView()
                .interactiveDismissDisabled()
        }
    }
}

struct NoTravelBoardsView: View {
    @Binding var showingSheet: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("🤔")
                .scaledToFit()
                .font(.system(size: 100))

            Text("No travel boards yet.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(
                "Create a new one by clicking the plus button in the top right corner."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()

    }
}

#Preview {
    TravelBoardsView()
}
