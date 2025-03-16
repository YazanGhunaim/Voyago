//
//  TravelBoardCardButtonView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardCardButtonView: View {
    let board: GeneratedTravelBoard

    var body: some View {
        NavigationLink {
            // MARK: TravelBoard details view
            TravelBoardDetailsView(travelBoard: board)
        } label: {
            // MARK: TravelBoard card
            TravelBoardCard(
                boardQuery: BoardQuery(
                    destination: board.queries.first!.destination,
                    days: board.queries.first!.days
                ),
                image: board.destinationImage
            )
        }
    }
}

#Preview {
    TravelBoardCardButtonView(board: mockTravelBoard)
}
