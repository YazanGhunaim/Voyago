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
    var viewState: ViewState = .Loading
}

extension GenItineraryViewModel {
    // Enum to distinguish viewstate
    enum ViewState: Equatable {
        case Loading
        case Success
        case Failure(errorMessage: String)
    }
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
            self.viewState = .Success
        case .failure(let error):
            VoyagoLogger.shared.logger.info(
                "Generated itinerary fetch failed with error: \(error)")
            self.generatedItinerary = nil
            self.viewState = .Failure(
                errorMessage:
                    "Itinerary generation failed. Please try again later.")
        }
    }

    // resets the viewmodel
    func reset() {
        self.generatedItinerary = nil
        self.viewState = .Loading
    }
}
