//
//  GenItineraryViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

/// GenItineraryViewModel responsible for managing data related to the generate itinerary view
@Observable
@MainActor
class GenItineraryViewModel {
    var generatedItinerary: VisualItinerary? = nil
}

extension GenItineraryViewModel {
    
    /// Gets the generated travel board from the voyago service
    /// - Parameter query: RecommendationQuery
    func getGeneratedTravelBoard(query: RecommendationQuery) async {
        VoyagoLogger.shared.logger.info("Fetching generated itinerary")
        
        let result =
            await VoyagoService.shared
            .fetchGeneratedTravelBoard(query: query)

        switch result {
        case .success(let generatedTravelBoard):
            VoyagoLogger.shared.logger.info(
                "Generated itinerary fetched successfully")
            self.generatedItinerary = generatedTravelBoard
        case .failure(let error):
            VoyagoLogger.shared.logger.info(
                "Generated itinerary fetch failed with error: \(error)")
            self.generatedItinerary = nil
        }
    }
    
    /// resets the viewmodel
    func reset() {
        self.generatedItinerary = nil
    }
}
