//
//  APIError.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/26/24.
//

import Foundation

/// An enum to represent possible errors during API requests.
enum APIError: Error {
    case invalidResponse
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
}
