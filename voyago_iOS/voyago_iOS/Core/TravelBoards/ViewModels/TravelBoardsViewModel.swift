//
//  TravelBoardsViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import Foundation

@Observable
@MainActor
class TravelBoardsViewModel {
    var travelBoards: UserTravelBoards?

    init() {
        Task { await self.getUserTravelBoards() }
    }
}

extension TravelBoardsViewModel {
    /// Gets user created travel boards from voyago service
    func getUserTravelBoards() async {
        let result = await VoyagoService.shared.fetchUserTravelBoards()

        switch result {
        case .success(let boards):
            VoyagoLogger.shared.logger.info(
                "Successfully retrieved user travel boards")
            
            self.travelBoards = boards
        case .failure(let error):
            VoyagoLogger.shared.logger.error(
                "Error getting user travel boards: \(error)"
            )
        }
    }
}
