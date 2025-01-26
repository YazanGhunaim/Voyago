//
//  RecommendationQuery.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

/// Model of the query used to generate a Travel Board
struct RecommendationQuery: Codable {
    let destination: String
    let days: Int
}
