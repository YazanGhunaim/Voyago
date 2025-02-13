//
//  MockedData.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

let mockVoyagoImage = VoyagoImage(
    username: "anthonydelanoix",
    unsplashProfile: "https://unsplash.com/@anthonydelanoix",
    urls: [
        "small":
            "https://images.unsplash.com/photo-1519677100203-a0e668c92439?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODIyMzV8MHwxfHNlYXJjaHwxfHxwcmFndWV8ZW58MHx8fHwxNzM3OTA3ODgwfDA&ixlib=rb-4.0.3&q=80&w=400",
        "regular":
            "https://images.unsplash.com/photo-1519677100203-a0e668c92439?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODIyMzV8MHwxfHNlYXJjaHwxfHxwcmFndWV8ZW58MHx8fHwxNzM3OTA3ODgwfDA&ixlib=rb-4.0.3&q=80&w=1080",
        "full":
            "https://images.unsplash.com/photo-1519677100203-a0e668c92439?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2ODIyMzV8MHwxfHNlYXJjaHwxfHxwcmFndWV8ZW58MHx8fHwxNzM3OTA3ODgwfDA&ixlib=rb-4.0.3&q=85",
    ]
)

let mockRecommendationQuery = RecommendationQuery(
    destination: "Czech Republic", days: 3)

let mockTravelBoard = GeneratedTravelBoard(
    plan: [
        DayPlan(
            day: 1,
            plan:
                "Go to the eiffer towerGo to the eiffer towerGo to the eiffer towerGo to the eiffer towerGo to the eiffer towerGo to the eiffer towerGo to the eiffer towerGo to the eiffer tower"
        ),
        DayPlan(
            day: 2,
            plan:
                "Go back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back homeGo back home"
        ),
    ],
    recommendations: [
        SightRecommendation(
            sight: "Notre-Dame Cathedral",
            brief: "A masterpiece of French Gothic architecture."
        ),
        SightRecommendation(
            sight: "Notre-Dame Cathedral",
            brief: "A masterpiece of French Gothic architecture."
        ),
        SightRecommendation(
            sight: "Notre-Dame Cathedral",
            brief: "A masterpiece of French Gothic architecture."
        ),
    ],
    images: [
        "Eiffel Tower": [mockVoyagoImage],
        "Louvre Museum": [mockVoyagoImage],
    ],
    recommendationQuery: RecommendationQuery(destination: "Paris", days: 2),
    destinationImage: mockVoyagoImage
)
