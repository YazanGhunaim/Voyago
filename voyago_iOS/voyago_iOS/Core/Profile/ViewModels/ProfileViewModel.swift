//
//  ProfileViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import Foundation

// TODO: User data
@Observable
@MainActor
class ProfileViewModel {
    var userBoards = [GeneratedTravelBoard]()
    var viewState: ViewState = .Loading

    init() {
        Task { await getUserTravelBoards(initial: true) }
    }
}

extension ProfileViewModel {
    /// ViewState enum
    enum ViewState: Equatable {
        case Loading
        case Fetching
        case Success
        case Failure(errorMessage: String)
    }
}

extension ProfileViewModel {
    /// Gets user created travel boards from voyago service
    func getUserTravelBoards(initial: Bool = false) async {
        if !initial {
            guard self.viewState != .Fetching else { return }
            self.viewState = .Fetching
        }

        let result = await VoyagoService.shared.fetchUserTravelBoards()

        switch result {
        case .success(let sessionResponse):
            self.userBoards = sessionResponse.boards.data
            self.viewState = .Success
            
            VoyagoLogger.shared.logger.info("Successfully retrieved user travel boards")
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Error getting user travel boards: \(error.localizedDescription)")

            self.viewState = .Failure(errorMessage: error.localizedDescription)
        }
    }
}
