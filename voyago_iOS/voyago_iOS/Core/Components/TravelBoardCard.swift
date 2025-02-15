//
//  TravelBoardCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import Kingfisher
import SwiftUI

struct TravelBoardCard: View {
    let recommendationQuery: RecommendationQuery
    let image: VoyagoImage

    private var tripDurationString: String {
        recommendationQuery.days > 1
            ? "\(self.recommendationQuery.days) days"
            : "\(self.recommendationQuery.days) day"
    }

    var body: some View {
        ZStack {
            // MARK: Destination background image
            VoyagoImageCard(image: image, cornerRadius: 0)

            // MARK: Destination Data
            HStack {
                Spacer()

                VStack(alignment: .center) {
                    Text("\(self.recommendationQuery.destination)")
                        .font(.largeTitle)

                    Text(tripDurationString)
                }
                .foregroundColor(.white)
                .padding()

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

#Preview {
    TravelBoardCard(
        recommendationQuery: RecommendationQuery(destination: "Czech Republic", days: 5),
        image: mockVoyagoImage
    )
}
