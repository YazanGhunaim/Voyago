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

    var body: some View {
        ZStack {
            // MARK: Destination background image
            KFImage(URL(string: self.image.regularUrl))
                .placeholder({ Rectangle().fill(Color.indigo).opacity(0.25) })
                .fade(duration: 1)
                .resizable()
            
            // MARK: Destination Data
            VStack(alignment: .center) {
                Text("\(self.recommendationQuery.destination)")
                    .font(.largeTitle)
                
                self.recommendationQuery.days > 1
                ? Text("\(self.recommendationQuery.days) days")
                : Text("\(self.recommendationQuery.days) day")
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .shadow(radius: 10)
    }
}

#Preview {
    TravelBoardCard(
        recommendationQuery: RecommendationQuery(
            destination: "Czech Republic", days: 5),
        image: voyagoImageMock)
}
