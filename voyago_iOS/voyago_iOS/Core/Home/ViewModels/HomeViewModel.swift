//
//  HomeViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/2/25.
//

import Foundation

/// HomeViewModel is responsible for:
///     - handling and processing data used in the HomeView
///     - managing and maintaining the viewstate
@Observable
@MainActor
class HomeViewModel {
    var images = [VoyagoImage]()
    var viewState: viewState?
    var page = 1

    let query: String

    init(keywords query: [String]) {
        self.query = query.joined(separator: " ")
        Task { await getImages(initial: true) }
    }
}

/// Splitting images array in half for pinterest like layout reasons
extension HomeViewModel {
    var firstHalfImages: [VoyagoImage] {
        let midIndex = images.count / 2
        return Array(images[..<midIndex])
    }

    var secondHalfImages: [VoyagoImage] {
        let midIndex = images.count / 2
        return Array(images[midIndex...])
    }
}

/// Enum to distinguish what state the viewmodel is in
extension HomeViewModel {
    enum viewState: Equatable {
        case Loading
        case Fetching
        case Success
        case Failure(errorMessage: String)
    }
}

/// Utility functions
extension HomeViewModel {
    /// reset viewmodel to initial state
    func reset() {
        self.page = 1
        self.viewState = nil
        self.images.removeAll()
    }

    /// reload view
    func reload(initial: Bool) async {
        self.reset()
        await self.getImages(initial: initial)
    }

    /// function to check whether or not the image viewed by the user is the last
    func lastImage(image: VoyagoImage) -> Bool {
        self.images.last?.id == image.id
    }
}

/// Networking functions
extension HomeViewModel {
    /// Gets Images for the home view feed, manages pagination and view state
    ///
    /// Uses the VoyagoService to fetch images for the current page.
    /// - Parameter initial: Boolean value determining wether this is the first call for this method
    ///     to correcltly manage view state
    func getImages(initial: Bool) async {
        if initial {
            guard self.viewState != .Loading else { return }
            self.viewState = .Loading
        } else {
            guard self.viewState != .Fetching else { return }
            self.viewState = .Fetching
        }

        defer { self.page += 1 }

        let result = await VoyagoService.shared.fetchImages(for: self.query, count: 10, page: self.page)

        switch result {
        case .success(let images):
            VoyagoLogger.shared.logger.info("Successfully fetched images for page \(self.page)")

            self.images += images
            self.viewState = .Success
            VoyagoLogger.shared.logger.info("Successfully fetched images for page \(self.page)")
        case .failure(let error):
            VoyagoLogger.shared.logger.info("Failed to fetch images with error: \(error)")

            self.viewState = .Failure(errorMessage: "An unexpected error occurred while loading data.")
        }
    }
}
