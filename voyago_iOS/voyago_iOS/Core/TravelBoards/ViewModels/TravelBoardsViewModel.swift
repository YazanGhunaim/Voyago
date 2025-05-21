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
    var travelBoards = [GeneratedTravelBoard]()
    var viewState: ViewState?

    init() {
        Task { await self.getUserTravelBoards(initial: true) }
    }
}

extension TravelBoardsViewModel {
    /// ViewState enum
    enum ViewState: Equatable {
        case Loading
        case Fetching
        case Success
        case Failure(errorMessage: String)
    }
}

extension TravelBoardsViewModel {
    /// Gets user created travel boards from voyago service
    func getUserTravelBoards(initial: Bool = false) async {
        if initial {
            guard self.viewState != .Loading else { return }
            self.viewState = .Loading
        } else {
            guard self.viewState != .Fetching else { return }
            self.viewState = .Fetching
        }

        let result = await VoyagoService.shared.fetchUserTravelBoards()

        switch result {
        case .success(let boards):
            self.travelBoards = boards
            self.viewState = .Success
            
            VoyagoLogger.shared.logger.info("Successfully retrieved user travel boards")
        case .failure(let error):
            self.viewState = .Failure(errorMessage: error.localizedDescription)
            
            VoyagoLogger.shared.logger.error("Error getting user travel boards: \(error.localizedDescription)")
        }
    }
}
