//
//  GenItineraryView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/28/25.
//

import SwiftUI

// TODO: Save previous generated itineraries
/// View of the generated itinerary
struct GenItineraryView: View {
    @State private var viewModel = GenItineraryViewModel()
    let destination: String
    let numOfDays: Int
    
    var body: some View {
        ZStack {
            VStack {
                if let itinerary = viewModel.generatedItinerary {
                    ItineraryDetailsView(destination: destination, itinerary: itinerary)
                } else {
                    VisualizingProgressView()
                }
            }
        }
        .task {
            let recommendationQuery = RecommendationQuery(destination: self.destination, days: self.numOfDays)
            await self.viewModel.getGeneratedTravelBoard(query: recommendationQuery)
        }
        .onDisappear {
            // FIXME: clicking on image card then going back shouldnt reset
            // self.viewModel.reset()
        }
        .navigationBarTitle("Generating Itinerary...", displayMode: .inline)
    }
}

// MARK: - Itinerary Details View
struct ItineraryDetailsView: View {
    let destination: String
    let itinerary: VisualItinerary

    var navTitle: String {
        "Your trip in \(destination)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Plan Section
                SectionContainer(title: "Plan") {
                    Text(itinerary.plan)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }

                // Sight Recommendations
                SectionContainer(title: "Places to Visit") {
                    ForEach(itinerary.recommendations, id: \.id) { recommendation in
                        SightRecommendationCard(recommendation: recommendation)
                    }
                }

                // Images Section
                SectionContainer(title: "Destination Highlights") {
                    ItineraryImagesView(itinerary: itinerary)
                }
            }
            .padding()
        }
        .navigationTitle(self.navTitle)
    }
}

// MARK: - Sight Recommendation Card
struct SightRecommendationCard: View {
    let recommendation: SightRecommendation

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text(recommendation.sight)
                    .font(.headline)
                Text(recommendation.brief)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}

// MARK: - Itinerary Images View
struct ItineraryImagesView: View {
    let itinerary: VisualItinerary

    var body: some View {
        TabView {
            ForEach(itinerary.images.keys.sorted(), id: \.self) { category in
                ForEach(itinerary.images[category] ?? [], id: \.id) { image in
                    ImageCard(image: image)
                }
            }
        }
        .tabViewStyle(.page)
        .frame(height: 200)
    }
}

/// Custom progress bar
struct VisualizingProgressView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(1.5)

                Text("Visualizing your trip...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 4)
            )
        }
    }
}

// MARK: - Section Container
struct SectionContainer<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.title)
                .font(.headline)
                .foregroundColor(.primary)

            self.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}

#Preview {
    GenItineraryView(destination: "Prague", numOfDays: 2)
}
