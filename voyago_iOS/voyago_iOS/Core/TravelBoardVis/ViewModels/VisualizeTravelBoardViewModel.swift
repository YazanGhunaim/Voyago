//
//  VisualizeTravelBoardViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

// VisualizeTravelBoardViewModel responsible for managing data related to the generate itinerary view
@Observable
@MainActor
class VisualizeTravelBoardViewModel {
    var visualizedBoard: GeneratedTravelBoard?
    var viewState: ViewState?
}

extension VisualizeTravelBoardViewModel {
    // Enum to distinguish viewstate
    enum ViewState: Equatable {
        case Loading
        case Success
        case Failure(errorMessage: String)
    }
}

extension VisualizeTravelBoardViewModel {
    // Gets the generated travel board from the voyago service
    func getGeneratedTravelBoard(query: BoardQuery) async {
        guard self.viewState != .Loading else { return }
        self.viewState = .Loading

        VoyagoLogger.shared.logger.info("Fetching generated itinerary")

        let result = await VoyagoService.shared.fetchGeneratedTravelBoard(query: query)

        switch result {
        case .success(let board):
            self.visualizedBoard = board
            self.viewState = .Success
            
            VoyagoLogger.shared.logger.info("Generated itinerary fetched successfully")
        case .failure(let error):
            self.visualizedBoard = nil
            self.viewState = .Failure(errorMessage: "Itinerary generation failed. Please try again later.")
            
            VoyagoLogger.shared.logger.info("Generated itinerary fetch failed with error: \(error)")
        }
    }

    // resets the viewmodel
    func reset() {
        self.visualizedBoard = nil
        self.viewState = nil
    }
}
