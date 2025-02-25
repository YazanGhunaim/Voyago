//
//  VoyagoService.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Foundation

struct NoResponse: Codable {

}
/// Service class to communicate with the Voyago REST API
class VoyagoService: APIClient {
    private let session: URLSession
    private let baseUrl = "http://192.168.0.101:8000"

    // singleton
    static let shared = VoyagoService()

    private init(session: URLSession = .shared) {
        self.session = session
    }
}

extension VoyagoService {
    private var accessToken: String? {
        AuthTokensKeychainManager.shared.getAccessToken()
    }

    private var refreshToken: String? {
        AuthTokensKeychainManager.shared.getRefreshToken()
    }

    private var isAuthenticated: Bool {
        (accessToken != nil) && (refreshToken != nil)
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

        guard let finalURL = urlComponents.url else { return .failure(APIError.invalidURL) }

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
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return .failure(APIError.encodingError(error))
            }
        }

        // Execute request
        do {
            VoyagoLogger.shared.logger.info("Voyago Service requesting: \(request)")

            let (data, response) = try await self.session.data(for: request)

            // Validate HTTP status code
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                return .failure(APIError.invalidResponse)
            }

            if httpResponse.statusCode == 204 {
                return .success(NoResponse() as! T)
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
    func fetchImages(for query: String, count: Int, page: Int) async -> Result<[VoyagoImage], APIError> {
        let parameters = [
            "query": query,
            "count": "\(count)",
            "page": "\(page)",
        ]

        let res: Result<[VoyagoImage], APIError> = await fetch(
            url: self.baseUrl + "/images",
            parameters: parameters,
            method: .GET,
            headers: [
                "Authorization": "Bearer \(self.accessToken!)",
                "refresh-token": "\(self.refreshToken!)",
            ]
        )
        return res
    }
}

extension VoyagoService {
    /// Fetches the generated travel board based on a recommendation query from the user
    /// - Parameter query: recommendation query
    func fetchGeneratedTravelBoard(query: RecommendationQuery) async -> Result<GeneratedTravelBoardResponse, APIError> {
        let res: Result<GeneratedTravelBoardResponse, APIError> = await fetch(
            url: self.baseUrl + "/itinerary",
            method: .POST,
            body: query,
            headers: [
                "Authorization": "Bearer \(self.accessToken!)",
                "refresh-token": "\(self.refreshToken!)",
            ]
        )

        return res
    }
}

extension VoyagoService {
    /// Fetches travel boards that the user created
    func fetchUserTravelBoards() async -> Result<UserTravelBoardsSessionResponse, APIError> {
        let res: Result<UserTravelBoardsSessionResponse, APIError> =
            await fetch(
                url: self.baseUrl + "/itinerary/user",
                method: .GET,
                headers: [
                    "Authorization": "Bearer \(self.accessToken!)",
                    "refresh-token": "\(self.refreshToken!)",
                ]
            )

        return res
    }
}

// MARK: - Token auth
extension VoyagoService {
    // validate existing user tokens in hand
    func validateTokens() async -> Result<AuthResponse, APIError> {
        let res: Result<AuthResponse, APIError> = await fetch(
            url: self.baseUrl + "/auth/validate_tokens", method: .GET,
            headers: [
                "Authorization": "Bearer \(self.accessToken!)",
                "refresh-token": "\(self.refreshToken!)",
            ]
        )

        return res
    }
}

// MARK: - User account Auth
extension VoyagoService {
    func signOut() async -> Result<NoResponse, APIError> {
        let res: Result<NoResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/sign_out", method: .POST,
            headers: [
                "Authorization": "Bearer \(self.accessToken!)",
                "refresh-token": "\(self.refreshToken!)",
            ]
        )

        return res
    }

    func deleteAccount() async -> Result<NoResponse, APIError> {
        let res: Result<NoResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/delete", method: .DELETE,
            headers: [
                "Authorization": "Bearer \(self.accessToken!)",
                "refresh-token": "\(self.refreshToken!)",
            ]
        )

        return res
    }
}

// MARK: - Auth Email and Password
extension VoyagoService {
    func signInWithEmailAndPassword(email: String, password: String) async -> Result<AuthResponse, APIError> {
        let credentials = UserSignInCredentials(email: email, password: password)
        let res: Result<AuthResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/sign_in",
            method: .POST,
            body: credentials
        )

        return res
    }

    func signUpWithEmailAndPassword(username: String, email: String, password: String)
        async -> Result<AuthResponse, APIError>
    {
        let credentials = UserSignUpCredentials(
            options: UserOptions(data: UserData(username: username)),
            email: email,
            password: password
        )
        let res: Result<AuthResponse, APIError> = await fetch(
            url: self.baseUrl + "/users/sign_up",
            method: .POST,
            body: credentials
        )

        return res
    }
}
