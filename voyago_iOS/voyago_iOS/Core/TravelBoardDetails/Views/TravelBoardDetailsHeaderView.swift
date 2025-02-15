//
//  TravelBoardDetailsHeaderView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardDetailsHeaderView: View {
    let recommendationQuery: RecommendationQuery
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your trip to")
                .font(.title)

            Text("\(recommendationQuery.destination)")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    TravelBoardDetailsHeaderView(recommendationQuery: mockRecommendationQuery, image: mockVoyagoImage)
}
