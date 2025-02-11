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

///// View of the generated itinerary
//struct TravelBoardDetailsView: View {
//    @State private var viewModel = TravelBoardDetailsViewModel()
//    let destination: String
//    let numOfDays: Int
//
//    var body: some View {
//        switch viewModel.viewState {
//        case .Loading:
//            VisualizingProgressView()
//                .navigationBarBackButtonHidden()
//                .navigationBarTitle(
//                    "Generating Itinerary...", displayMode: .inline
//                )
//                .task {
//                    let recommendationQuery = RecommendationQuery(
//                        destination: self.destination, days: self.numOfDays)
//                    await self.viewModel.getGeneratedTravelBoard(
//                        query: recommendationQuery)
//                }
//        case .Success:
//            if let itinerary = viewModel.generatedItinerary {
//                ItineraryDetailsView(
//                    destination: destination, itinerary: itinerary
//                )
//                .onDisappear {
//                    // FIXME: clicking on image card then going back shouldnt reset
//                    // self.viewModel.reset()
//                }
//            }
//        case .Failure(_):
//            ErrorView(
//                //                errorMessage: errorMessage,
//                onReload: {}  // TODO: on reload
//            )
//        }
//    }
//}
//
//// MARK: - Itinerary Details View
//struct ItineraryDetailsView: View {
//    let destination: String
//    let itinerary: GeneratedTravelBoard
//
//    var navTitle: String {
//        "Your trip in \(destination)"
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // Plan Section
//                SectionContainer(title: "Plan") {
//                    ForEach(itinerary.plan, id: \.self) { dayPlan in
//                        Text("Day: \(dayPlan.day)")
//                        Text(dayPlan.plan)
//                    }
//                }
//
//                // Sight Recommendations
//                SectionContainer(title: "Places to Visit") {
//                    ForEach(itinerary.recommendations, id: \.id) {
//                        recommendation in
//                        SightRecommendationCard(recommendation: recommendation)
//                    }
//                }
//
//                // Images Section
//                SectionContainer(title: "Destination Highlights") {
//                    ItineraryImagesView(itinerary: itinerary)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(self.navTitle)
//    }
//}
//
//// MARK: - Sight Recommendation Card
//struct SightRecommendationCard: View {
//    let recommendation: SightRecommendation
//
//    var body: some View {
//        HStack(spacing: 12) {
//            VStack(alignment: .leading) {
//                Text(recommendation.sight)
//                    .font(.headline)
//                Text(recommendation.brief)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .lineLimit(3)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//    }
//}
//
//// MARK: - Itinerary Images View
//struct ItineraryImagesView: View {
//    let itinerary: GeneratedTravelBoard
//
//    var body: some View {
//        TabView {
//            ForEach(itinerary.images.keys.sorted(), id: \.self) { category in
//                ForEach(itinerary.images[category] ?? [], id: \.id) { image in
//                    ImageCard(image: image)
//                }
//            }
//        }
//        .tabViewStyle(.page)
//        .frame(height: 200)
//    }
//}
//
///// Custom progress bar
//struct VisualizingProgressView: View {
//    var body: some View {
//        ZStack {
//            VStack(spacing: 10) {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
//                    .scaleEffect(1.5)
//
//                Text("Visualizing your trip...")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color(.systemGray6))
//                    .shadow(radius: 4)
//            )
//        }
//    }
//}
//
//// MARK: - Section Container
//struct SectionContainer<Content: View>: View {
//    let title: String
//    let content: Content
//
//    init(title: String, @ViewBuilder content: () -> Content) {
//        self.title = title
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(self.title)
//                .font(.headline)
//                .foregroundColor(.primary)
//
//            self.content
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//    }
//}

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
