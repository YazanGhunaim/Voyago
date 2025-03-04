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
        self.userSessionState = validTokens ? .loggedIn : .loggedOut
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

            VoyagoLogger.shared.logger.info("Tokens in hand are valid")
            return true
        case .failure(_):
            VoyagoLogger.shared.logger.info("Tokens in hand are invalid")
            return false
        }
    }
}

// MARK: - General auth functions
extension AuthViewModel {
    func signOut() async {
        let result = await VoyagoService.shared.signOut()

        switch result {
        case .success(_):
            VoyagoLogger.shared.logger.info("Successfully signed out user")

            self.userSessionState = .loggedOut
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to sign out user with error: \(error)")
        }
    }

    func deleteAccount() async {
        let result = await VoyagoService.shared.deleteAccount()

        switch result {
        case .success(_):
            VoyagoLogger.shared.logger.info("Successfully deleted user")

            self.userSessionState = .loggedOut
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to delete user with error: \(error)")
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
