//
//  APIClient.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/26/24.
//

import Foundation

/// A protocol defining an API client
protocol APIClient {

    
    /// Fetches data from a given url
    /// - Parameters:
    ///   - url: URL endpoint being called
    ///   - parameters: Optional list of parameters
    /// - Returns: Result type containing decoded response or an error
    func fetch<T: Decodable>(
        url: String,
        parameters: [String: String]?
    ) async -> Result<T, APIError>
}
