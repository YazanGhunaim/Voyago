//
//  TravelBoard.swift
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

/// Model of the generated travel board, without query metadata ( straight after generation )
struct GeneratedTravelBoard: Codable {
    var id = UUID()

    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]

    let recommendationQuery: RecommendationQuery
    let destinationImage: VoyagoImage

    enum CodingKeys: String, CodingKey {
        case plan, recommendations, images
        case destinationImage = "destination_image"
        case recommendationQuery = "recommendation_queries"
    }
}

struct GeneratedTravelBoardResponse: Codable {
    let board: [GeneratedTravelBoard]
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case board = "data"
        case count
    }
}

struct UserTravelBoards: Codable {
    let data: [GeneratedTravelBoard]
    let count: Int?
}

// User travel boards alongside his auth tokens
struct UserTravelBoardsSessionResponse: Codable {
    let boards: UserTravelBoards
    let authTokens: UserTokens

    enum CodingKeys: String, CodingKey {
        case boards = "response"
        case authTokens = "auth_tokens"
    }
}
