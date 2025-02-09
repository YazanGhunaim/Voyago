//
//  TravelBoardsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import SwiftUI

// TODO: Refreshable
// TODO: Cache travel boards [ model conversion to swiftdata ]
// TODO: No previous travel boards view
struct TravelBoardsView: View {
    @State private var viewModel = TravelBoardsViewModel()
    @State private var showingSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.travelBoards!.data, id: \.id) { board in
                        TravelBoardCard(
                            recommendationQuery: RecommendationQuery(
                                destination: board.destination, days: board.days
                            ),
                            image: voyagoImageMock)
                    }
                }
            }
            .navigationTitle("Travel boards")
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
}

#Preview {
    TravelBoardsView()
}
