//
//  GeneratedTravelBoard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 3/16/25.
//

import Foundation

/// Model of the generated travel board, without query metadata ( straight after generation )
struct GeneratedTravelBoard: Codable {
    var id = UUID()

    let destinationImage: VoyagoImage
    let plan: [DayPlan]
    let recommendations: [SightRecommendation]
    let images: [String: [VoyagoImage]]
    let queries: [BoardQuery]

    // getter for the singular query used to generate this board
    // its a list due to supabase return format, but only 1 query generates a board
    var query: BoardQuery {
        queries.first!
    }

    enum CodingKeys: String, CodingKey {
        case destinationImage = "destination_image"
        case queries = "board_queries"
        case recommendations = "sight_recommendations"

        case plan, images
    }
}
