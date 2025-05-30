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
    case unauthorized
    case decodingError(Error)  // unable to decode response to required data format
    case encodingError(Error)  // unable to encode data
    case networkError(Error)  // status codes etc.
}
