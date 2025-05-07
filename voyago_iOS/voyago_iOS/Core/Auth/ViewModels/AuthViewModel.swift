//
//  AuthViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//
import Foundation

// TODO: log out when user tokens are invalid
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
        let userSessionIsValid = await setUserSession()
        self.userSessionState = userSessionIsValid ? .loggedIn : .loggedOut
    }

    // Checks if user session exists, if so saves the returned AuthTokens to keychain
    // If valid tokens already in hand, refreshed access token if need be
    private func setUserSession() async -> Bool {
        guard AuthTokensKeychainManager.shared.authTokensExist() else { return false }

        let result = await VoyagoService.shared.setUserSession()

        switch result {
        case .success(let authResponse):
            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )

            VoyagoLogger.shared.logger.info("Successfully set user session.")
            return true
        case .failure(_):
            VoyagoLogger.shared.logger.error("Failed to set user session.")
            return false
        }
    }

    private func handleSessionExpiration() {
        self.userSessionState = .loggedOut
        if !AuthTokensKeychainManager.shared.deleteAuthTokens() {
            VoyagoLogger.shared.logger.error("Failed to delete Auth Tokens from keychain.")
        }
    }
}

// MARK: - General auth functions
extension AuthViewModel {
    func signOut() async {
        let result = await VoyagoService.shared.signOut()

        switch result {
        case .success(_):
            handleSessionExpiration()
            VoyagoLogger.shared.logger.info("Successfully signed out user")
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to sign out user with error: \(error)")
        }
    }

    func deleteAccount() async {
        let result = await VoyagoService.shared.deleteAccount()

        switch result {
        case .success(_):
            handleSessionExpiration()
            VoyagoLogger.shared.logger.info("Successfully deleted user")
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
            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )
            self.userSessionState = .loggedIn
            
            VoyagoLogger.shared.logger.info("Successfully logged in with email and password")
            
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to login with email and password: \(error)")
            return false
        }
    }

    func registerWithEmailAndPassword(name: String, username: String, email: String, password: String) async -> Bool {
        let result = await VoyagoService.shared.signUpWithEmailAndPassword(
            name: name, username: username, email: email, password: password
        )

        switch result {
        case .success(let authResponse):
            AuthTokensKeychainManager.shared.saveAuthTokens(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )
            
            VoyagoLogger.shared.logger.info("Successfully Signed up with email and password")

            self.userSessionState = .loggedIn
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error("Failed to Sign up with email and password: \(error)")
            return false
        }
    }
}
