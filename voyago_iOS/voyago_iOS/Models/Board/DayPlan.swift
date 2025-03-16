//
//  DayPlan.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 3/16/25.
//

import Foundation

/// A model for a single day plan
struct DayPlan: Codable, Hashable {
    let day: Int
    let plan: String
}
