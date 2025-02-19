//
//  TravelBoardSightDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardSightDetailsView: View {
    let board: GeneratedTravelBoard

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(board.recommendations, id: \.id) { recommendation in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(recommendation.sight)
                            .font(.headline)

                        Text(recommendation.brief)

                        VoyagoImageCard(image: board.images[recommendation.sight]!.first!, cornerRadius: 15)
                            .frame(height: 250)
                            .scaledToFit()
                    }
                    .padding()
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.thinMaterial)
                            .stroke(.primary, lineWidth: 0.5)
                            .shadow(color: .primary, radius: 1)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(20, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}
