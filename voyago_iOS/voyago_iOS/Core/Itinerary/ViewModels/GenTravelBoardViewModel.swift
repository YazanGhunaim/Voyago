//
//  GenTravelBoardViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Foundation

@Observable
@MainActor
class GenTravelBoardViewModel {
    var generatedTravelBoard: VisualItinerary?
}

extension GenTravelBoardViewModel {
    func getGeneratedTravelBoard(query: RecommendationQuery) async {
        let result =
            await VoyagoService.shared
            .fetchGeneratedTravelBoard(query: query)

        switch result {
        case .success(let generatedTravelBoard):
            self.generatedTravelBoard = generatedTravelBoard
        case .failure:
            self.generatedTravelBoard = nil
        }
    }
}
