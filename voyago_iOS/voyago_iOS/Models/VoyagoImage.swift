//
//  VoyagoImage.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/14/25.
//

import Foundation

/// Data connected with an image.
struct VoyagoImage: Codable {
    let id = UUID()  // id of image
    let username: String  // Photographer's username
    let unsplashProfile: String?  // Optional Unsplash profile URL

    private let urls: [String: String]  // [resolution: url]

    init(username: String, unsplashProfile: String? = nil, urls: [String: String]) {
        self.username = username
        self.unsplashProfile = unsplashProfile
        self.urls = urls
    }
}

extension VoyagoImage {
    // TODO: - Enum for sizes rather than literals
    var smallUrl: String { urls["small"] ?? "" }
    var regularUrl: String { urls["regular"] ?? "" }
    var fullUrl: String { urls["full"] ?? "" }
}

extension VoyagoImage {
    enum CodingKeys: String, CodingKey {
        case urls
        case username
        case unsplashProfile = "unsplash_profile"
    }
}
