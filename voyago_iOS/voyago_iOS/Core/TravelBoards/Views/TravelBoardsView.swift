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
                        TravelBoardCardButtonView(board: board)
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
        }
    }
}

struct TravelBoardCardButtonView: View {
    let board: GeneratedTravelBoard

    var body: some View {
        NavigationLink {
            // MARK: TravelBoard details view
            TravelBoardDetailsView(travelBoard: board)
        } label: {
            // MARK: TravelBoard card
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

/// Custom progress bar
struct VisualizingProgressView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(1.5)

                Text("Visualizing your trip...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 4)
            )
        }
    }
}

#Preview {
    TravelBoardsView()
}
