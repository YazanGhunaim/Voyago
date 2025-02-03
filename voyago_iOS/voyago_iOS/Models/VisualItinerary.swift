//
//  VisualItinerary.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

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
    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]
}
