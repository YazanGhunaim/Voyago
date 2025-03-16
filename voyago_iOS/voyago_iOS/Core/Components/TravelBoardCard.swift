//
//  TravelBoardCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import Kingfisher
import SwiftUI

struct TravelBoardCard: View {
    let boardQuery: BoardQuery
    let image: VoyagoImage

    private var tripDurationString: String {
        boardQuery.days > 1
            ? "\(self.boardQuery.days) days"
            : "\(self.boardQuery.days) day"
    }

    var body: some View {
        ZStack {
            // MARK: Destination background image
            VoyagoImageCard(image: image, cornerRadius: 0)

            // MARK: Destination Data
            HStack {
                VStack(alignment: .center) {
                    Text("\(self.boardQuery.destination)")
                        .font(.largeTitle)
                        .shadow(color: .black, radius: 0.25)  // stroke workaround

                    Text(tripDurationString)
                        .shadow(color: .black, radius: 0.25)  // stroke workaround
                }
                .foregroundColor(.white)
                .padding()
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

#Preview {
    TravelBoardCard(
        boardQuery: BoardQuery(destination: "Czech Republic", days: 5),
        image: mockVoyagoImage
    )
}
