//
//  SightRecommendations.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 3/16/25.
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
