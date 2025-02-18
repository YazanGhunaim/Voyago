//
//  TravelBoardDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/28/25.
//

import Kingfisher
import SwiftUI

struct TravelBoardDetailsView: View {
    let travelBoard: GeneratedTravelBoard

    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: View header titles
                TravelBoardDetailsHeaderView(
                    recommendationQuery: travelBoard.recommendationQuery,
                    image: travelBoard.destinationImage
                )

                // MARK: TravelBoard section details
                TravelBoardSectionDetailsView(dailyPlan: travelBoard.plan)

                // MARK: Places to visit
                TravelBoardPlacesToVisitView(recommendations: travelBoard.recommendations)

                // MARK: Board Images
                TravelBoardImagesView(images: travelBoard.images)
            }
        }
    }
}

#Preview {
    TravelBoardDetailsView(travelBoard: mockTravelBoard)
}
