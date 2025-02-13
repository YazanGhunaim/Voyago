//
//  VoyagoService.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Foundation

/// Service class to communicate with the Voyago REST API
class VoyagoService: APIClient {
    private let session: URLSession
    private let baseUrl = "http://192.168.0.122:8000"

    // singleton
    static let shared = VoyagoService()

    private init(session: URLSession = .shared) {
        self.session = session
    }
}

extension VoyagoService {
    func fetch<T>(
        url: String,
        parameters: [String: String]? = nil,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        headers: [String: String]? = nil
    ) async -> Result<T, APIError> where T: Decodable {
        // Construct URL
        guard var urlComponents = URLComponents(string: url) else {
            return .failure(APIError.invalidURL)
        }

        // Add query parameters for GET requests
        if let parameters, method == .GET {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let finalURL = urlComponents.url else {
            return .failure(APIError.invalidURL)
        }

        // Create URLRequest
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        // Add headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Add body for POST/PUT requests
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue(
                    "application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return .failure(APIError.encodingError(error))
            }
        }

        // Execute request
        do {
            VoyagoLogger.shared.logger.info(
                "Voyago Service attempting request: \(request)")
            let (data, response) = try await self.session.data(for: request)

            // Validate HTTP status code
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                return .failure(APIError.invalidResponse)
            }

            // Decode response
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(APIError.networkError(error))
        }
    }
}

extension VoyagoService {
    /// Fetches images related to a certain query
    /// - Parameters:
    ///   - query: Image query, multiple keywords seperated by spaces are supported
    ///   - count: Number of images
    ///   - page: Page number
    /// - Returns: List of URL's
    func fetchImages(for query: String, count: Int, page: Int) async -> Result<
        [VoyagoImage], APIError
    > {
        let parameters = [
            "query": query,
            "count": "\(count)",
            "page": "\(page)",
        ]

        let res: Result<[VoyagoImage], APIError> = await fetch(
            url: self.baseUrl + "/images", parameters: parameters
        )

        return res
    }
}

extension VoyagoService {
    /// Fetches the generated travel board based on a recommendation query from the user
    /// - Parameter query: recommendation query
    func fetchGeneratedTravelBoard(query: RecommendationQuery)
        async -> Result<
            GeneratedTravelBoard, APIError
        >
    {
        let res: Result<GeneratedTravelBoard, APIError> = await fetch(
            url: self.baseUrl + "/itinerary", method: .POST, body: query
        )

        return res
    }
}

extension VoyagoService {
    /// Fetches travel boards that the user created
    // TODO: pass user auth headers
    func fetchUserTravelBoards() async -> Result<
        UserTravelBoards, APIError
    > {
        let res: Result<UserTravelBoards, APIError> = await fetch(
            url: self.baseUrl + "/itinerary/user",
            method: .GET,
            headers: [
                "Authorization":
                    "Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6InZieXJHR3NaT2FrYzluYTUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2NqaHV6bWZjbXd4cnZtdWJjY21xLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiIwY2M3ZWMxMS05ZjY0LTQ2NWEtODRiNy0zOTJlMmZkYzczMDciLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzM5MjE3NDgzLCJpYXQiOjE3MzkyMTM4ODMsImVtYWlsIjoieWF6YW5naHVuYWltMDdAZ21haWwuY29tIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdfSwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbCI6InlhemFuZ2h1bmFpbTA3QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwaG9uZV92ZXJpZmllZCI6ZmFsc2UsInN1YiI6IjBjYzdlYzExLTlmNjQtNDY1YS04NGI3LTM5MmUyZmRjNzMwNyJ9LCJyb2xlIjoiYXV0aGVudGljYXRlZCIsImFhbCI6ImFhbDEiLCJhbXIiOlt7Im1ldGhvZCI6InBhc3N3b3JkIiwidGltZXN0YW1wIjoxNzM5MjEzODgzfV0sInNlc3Npb25faWQiOiI5OGM0MGRmNi1hYjIzLTQ5ZDgtODE1Yy1lMWZmYjVlYWRlYzUiLCJpc19hbm9ueW1vdXMiOmZhbHNlfQ.73MA-fU40FusRbMLCCwJlGjuf0HVkfCi9fsn4P_J18M",
                "refresh-token": "808DjJ46P-Mmqx-lrqiGtg",
            ])

        return res
    }
}

// MARK: - Auth Email and Password
extension VoyagoService {
    func signInWithEmailAndPassword(withCredentials creditials: UserCredintials)
        async -> Result<AuthResponse, APIError>
    {
        let res: Result<AuthResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/sign_in",
            method: .POST,
            body: creditials
        )

        return res
    }

    func signUpWithEmailAndPassword(withCredentials creditials: UserCredintials)
        async -> Result<AuthResponse, APIError>
    {
        let res: Result<AuthResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/sign_up",
            method: .POST,
            body: creditials
        )

        return res
    }
}
