//
//  VoyagoService.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Foundation

typealias ImageURLS = [String]

/// Service class to communicate with the Voyago REST API
class VoyagoService: APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T>(url: String, parameters: [String: String]? = nil) async
        -> Result<T, APIError> where T: Decodable
    {
        guard var urlComponents = URLComponents(string: url) else {
            return .failure(APIError.invalidURL)
        }

        // set parameters
        if let parameters {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let finalURL = urlComponents.url else {
            return .failure(APIError.invalidURL)
        }

        do {
            let (data, response) = try await self.session.data(from: finalURL)

            // check HTTP status code
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                return .failure(APIError.invalidResponse)
            }

            // Decode response data to specific type
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(APIError.decodingError(error))
        }
    }

    /// Fetches images related to a certain query
    /// - Parameters:
    ///   - query: Image query, multiple keywords seperated by spaces are supported
    ///   - count: Number of images
    ///   - page: Page number
    /// - Returns: List of URL's
    func fetchImages(for query: String, count: Int, page: Int) async -> Result<
        ImageURLS, APIError
    > {
        let parameters = [
            "query": query,
            "count": "\(count)",
            "page": "\(page)",
        ]

        return await fetch(
            url: "http://127.0.0.1:8000/images", parameters: parameters)
    }
}
