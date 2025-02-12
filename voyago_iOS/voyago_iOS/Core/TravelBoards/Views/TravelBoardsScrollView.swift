//
//  TravelBoardsScrollView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

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

//#Preview {
//    TravelBoardsScrollView()
//}
