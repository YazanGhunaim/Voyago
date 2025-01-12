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
    var imageUrls = [String]()
    var viewState: viewState?
    var page = 1

    let query: String

    init(keywords query: [String]) {
        self.query = query.joined(separator: " ")
        Task { await getImages(initial: true) }
    }
}

/// Splitting image url's array in half for pinterest like layout reasons
extension HomeViewModel {
    var firstHalfImageUrls: [String] {
        let midIndex = imageUrls.count / 2
        return Array(imageUrls[..<midIndex])
    }

    var secondHalfImageUrls: [String] {
        let midIndex = imageUrls.count / 2
        return Array(imageUrls[midIndex...])
    }
}

/// Enum to distinguish what state the viewmodel is in
extension HomeViewModel {
    enum viewState {
        case Loading
        case Fetching
        case Success
        case Failure
    }
}

/// Utility functions
extension HomeViewModel {
    /// reset viewmodel to initial state
    func reset() {
        self.page = 1
        self.viewState = nil
        self.imageUrls.removeAll()
    }

    /// function to check whether or not the image viewed by the user is the last
    func lastImage(imageUrl: String) -> Bool {
        self.imageUrls.last == imageUrl
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

        let result = await VoyagoService.shared.fetchImages(
            for: self.query, count: 10, page: self.page)

        switch result {
        case .success(let images):
            VoyagoLogger.shared.logger.log(
                level: .info,
                "Successfully fetched images for page \(self.page, privacy: .public)"
            )
            self.imageUrls += images
            self.viewState = .Success
        case .failure(let error):
            VoyagoLogger.shared.logger.log(
                level: .error,
                "Failed to fetch images with error: \(error.localizedDescription, privacy: .public)"
            )
            self.viewState = .Failure
        }
    }
}
