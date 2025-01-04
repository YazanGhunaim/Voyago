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
    var images = [String]()
    var succeeded: Bool = false

    init() {
        Task { await getImages() }
    }

    func getImages() async {
        let result = await VoyagoService.shared.fetchImages(
            for: "Travel Cities Sights", count: 10, page: 1
        )

        switch result {
        case .success(let images):
            self.images = images
            self.succeeded = true
        case .failure(let error):
            print("DEBUG: failed to fetch images with error: \(error)")
            self.succeeded = false
        }
    }
}
