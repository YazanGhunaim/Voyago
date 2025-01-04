//
//  HomeViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/2/25.
//

import Foundation

/// HomeViewModel is responsible of handling data used by the home view
@Observable
@MainActor
class HomeViewModel {
    var imageUrls = [String]()
    var page = 1

    let query: String
    var viewState: viewState?

    init(keywords query: [String]) {
        self.query = query.joined(separator: " ")
        Task { await getImages() }
    }

    /// function to check whether or not the image viewed by the user is the last
    /// this is used for pagination purposes
    func lastImage(imageUrl: String) -> Bool {
        self.imageUrls.last == imageUrl
    }

    func getImages() async {
        guard self.viewState != .Loading else { return }
        self.viewState = .Loading

        let result = await VoyagoService.shared.fetchImages(
            for: self.query, count: 10, page: self.page
        )

        switch result {
        case .success(let images):
            self.imageUrls = images
            self.viewState = .Success
        case .failure(let error):
            print("DEBUG: failed to fetch images with error: \(error)")
            self.viewState = .Failure
        }
    }

    func getMoreImages() async {
        self.viewState = .Fetching
        self.page += 1
        
        let result = await VoyagoService.shared.fetchImages(
            for: self.query, count: 10, page: self.page
        )

        switch result {
        case .success(let images):
            self.imageUrls += images
            self.viewState = .Success
        case .failure(let error):
            print("DEBUG: failed to fetch images with error: \(error)")
            self.viewState = .Failure
        }
    }
}

/// Enum to distinguish what state the viewmodel is in, for pagination
extension HomeViewModel {
    enum viewState {
        case Loading
        case Fetching
        case Success
        case Failure
    }
}
