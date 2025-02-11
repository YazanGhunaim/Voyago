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
                    recommendationQuery: travelBoard.recommendationQuery!)

                // MARK: TravelBoard section details
                TravelBoardSectionDetailsView(dailyPlan: travelBoard.plan)

                // MARK: Places to visit
                TravelBoardPlacesToVisitView(
                    recommendations: travelBoard.recommendations)

                // MARK: Board Images
                TravelBoardImagesView(images: travelBoard.images)
            }
        }
    }
}

struct TravelBoardDetailsHeaderView: View {
    let recommendationQuery: RecommendationQuery

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your trip to")
                .font(.title)

            Text("\(recommendationQuery.destination)")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct TravelBoardSectionDetailsView: View {
    let dailyPlan: [DayPlan]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Plan")
                    .bold()

                VStack(alignment: .leading, spacing: 15) {
                    // MARK: Daily plans
                    ForEach(dailyPlan, id: \.hashValue) { plan in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Day: \(plan.day)")
                                .font(.headline)

                            Text("\(plan.plan)")

                            // MARK: picture?
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    Color(.systemPurple).opacity(0.1))
                        }
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        }
        .padding(.horizontal)
    }
}

struct TravelBoardPlacesToVisitView: View {
    let recommendations: [SightRecommendation]

    var body: some View {
        ZStack {
            // MARK: Section title
            VStack(alignment: .leading, spacing: 15) {
                Text("Places to visit")
                    .bold()

                ForEach(recommendations, id: \.id) {
                    recommendation in
                    // MARK: sight recommendation card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(recommendation.sight)")
                            .font(.headline)

                        Text("\(recommendation.brief)")

                        // MARK: picture?
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemPurple).opacity(0.1))
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        }
        .padding()
    }
}

struct TravelBoardImagesView: View {
    let images: [String: [VoyagoImage]]

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Sights")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(
                        images.keys.sorted(), id: \.self
                    ) {
                        sight in
                        ForEach(
                            images[sight] ?? [],
                            id: \.id
                        ) {
                            image in
                            KFImage(URL(string: image.regularUrl))  // TODO: Board view
                                .resizable()
                                .frame(width: 250, height: 250)
                                //                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .containerRelativeFrame(
                        .horizontal, count: 1, spacing: 0)

                }
                .scrollTargetLayout()
            }
            .contentMargins(20, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    TravelBoardDetailsView(travelBoard: mockTravelBoard)
}
