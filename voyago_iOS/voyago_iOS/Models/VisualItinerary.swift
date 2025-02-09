//
//  VisualItinerary.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

// TODO: WHAT THE ACTUAL FUCK IS THIS BECOMING (REFACTOR EVERYWHERE)
// TODO: LINE ABOVE
/// A model for a single sight recommendation
struct SightRecommendation: Codable {
    var id = UUID()

    let sight: String
    let brief: String

    enum CodingKeys: String, CodingKey {
        case sight
        case brief
    }
}

/// A model for a single day plan
struct DayPlan: Codable, Hashable {
    let day: Int
    let plan: String
}

/// A model for the expected itinerary returned by the LLM
struct Itinerary: Codable {
    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
}

/// A model for the full trip plan provided to users
struct VisualItinerary: Codable {
    var id = UUID()

    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]
}

/// A model representing previous user generated itinerary from storage
struct UserVisualItinerary: Codable {
    let id: String
    let createdAt: String

    let destination: String
    let days: Int

    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]

    enum CodingKeys: String, CodingKey {
        case id, destination, days, plan, recommendations, images
        case createdAt = "created_at"
    }
}

struct UserVisualItineraries: Codable {
    let data: [UserVisualItinerary]
}
