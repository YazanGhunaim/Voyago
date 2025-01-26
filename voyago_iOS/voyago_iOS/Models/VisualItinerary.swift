//
//  VisualItinerary.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

// A model for a single sight recommendation
struct SightRecommendation: Codable {
    let sight: String
    let brief: String
}

// A model for the expected itinerary returned by the LLM
struct Itinerary: Codable {
    let plan: String
    let recommendations: [SightRecommendation]
}

// A model for the full trip plan provided to users
struct VisualItinerary: Codable {
    let plan: String
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]
}
