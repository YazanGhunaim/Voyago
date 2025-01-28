//
//  GenItineraryView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/28/25.
//

import SwiftUI

// TODO: Save previous generated itineraries
struct GenItineraryView: View {
    @State private var viewModel = GenItineraryViewModel()

    let destination: String
    let numOfDays: Int

    var body: some View {
        VStack {
            if let itinerary = viewModel.generatedItinerary {
                // MARK: Itinerary Details
                ItineraryDetailsView(
                    destination: self.destination, itinerary: itinerary)
            } else {
                // MARK: Progress view
                VisualizingProgressView()
            }
        }
        .task {
            let recommendationQuery = RecommendationQuery(
                destination: self.destination, days: self.numOfDays)
            await self.viewModel.getGeneratedTravelBoard(
                query: recommendationQuery)
        }
        .onDisappear {
            // FIXME: clicking on image card then going back shouldnt reset
            self.viewModel.reset()
        }
    }
}

// TODO: Upgrade UI
struct ItineraryDetailsView: View {
    let destination: String
    let itinerary: VisualItinerary

    var navTitle: String {
        "Your trip in \(destination)"
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                // MARK: Plan
                VStack(alignment: .leading) {
                    Text("Plan:")
                        .font(.subheadline)

                    Text(itinerary.plan)
                        .multilineTextAlignment(.leading)
                }

                Divider()

                // MARK: Sight Recommendations
                VStack(alignment: .leading, spacing: 10) {
                    Text("Places to visit:")
                        .font(.subheadline)

                    ForEach(self.itinerary.recommendations, id: \.id) {
                        recommendation in
                        VStack(alignment: .leading) {
                            Text("\(recommendation.sight):")
                                .bold()

                            Text(recommendation.brief)
                        }
                    }
                }

                Divider()

                // MARK: Sight Images
                // TODO: UI change to smth similar to deck of cards?
                ForEach(itinerary.images.keys.sorted(), id: \.self) {
                    category in
                    ForEach(itinerary.images[category] ?? [], id: \.id) {
                        image in
                        ImageCard(image: image)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(self.navTitle)
    }
}

struct VisualizingProgressView: View {
    var body: some View {
        ProgressView {
            Text("Visualizing...")
        }
        .tint(.indigo)
    }
}

#Preview {
    GenItineraryView(destination: "Prague", numOfDays: 2)
}
