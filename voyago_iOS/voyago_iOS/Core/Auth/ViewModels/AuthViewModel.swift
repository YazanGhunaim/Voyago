//
//  AuthViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//
import Foundation

@Observable
@MainActor
class AuthViewModel {
    var userSessionState: userSessionState?

    init() { Task { await setUserSessionState() } }
}

// MARK: - Auth tokens management
extension AuthViewModel {
    // Session state enum
    enum userSessionState {
        case loggedIn
        case loggedOut
    }

    // Sets the user session state
    private func setUserSessionState() async {
        let validTokens = await validAuthTokens()
        if validTokens {
            self.userSessionState = .loggedIn
        } else {
            self.userSessionState = .loggedOut
        }
    }

    // checks if exist valid tokens
    private func validAuthTokens() async -> Bool {
        //        guard AuthTokensKeychainManager.shared.authTokensExist() else { return false }

        let result = await VoyagoService.shared.validateTokens()

        switch result {
        case .success(let authResponse):
            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )

            VoyagoLogger.shared.logger.info("Existing tokens valid, updating tokens")
            return true
        case .failure(_):
            VoyagoLogger.shared.logger.info("Existing tokens are invalid")
            return false
        }
    }
}

// MARK: - Email and Password
extension AuthViewModel {
    func loginWithEmailAndPassword(email: String, password: String) async -> Bool {
        let result = await VoyagoService.shared.signInWithEmailAndPassword(email: email, password: password)

        switch result {
        case .success(let authResponse):
            VoyagoLogger.shared.logger.info("Successfully logged in with email and password")

            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )

            self.userSessionState = .loggedIn
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to login with email and password: \(error)")
            return false
        }
    }

    func registerWithEmailAndPassword(username: String, email: String, password: String) async -> Bool {
        let result = await VoyagoService.shared.signUpWithEmailAndPassword(
            username: username, email: email, password: password)

        switch result {
        case .success(let authResponse):
            VoyagoLogger.shared.logger.info("Successfully Signed up with email and password")

            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )

            self.userSessionState = .loggedIn
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to Sign up with email and password: \(error)")
            return false
        }
    }
}
