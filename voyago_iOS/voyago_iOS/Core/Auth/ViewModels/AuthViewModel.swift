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
    var userTokens: UserTokens?

    var isLoggedIn: Bool {  // TODO: update keychain when refresh token is used
        false
        //        guard
        //            AuthTokensKeychainManager.shared.getToken(forKey: .accessToken)
        //                != nil
        //        else { return false }
        //        return true
    }
}

// MARK: - Auth tokens management
extension AuthViewModel {
    private func saveAuthTokens() {
        if let tokens = userTokens {
            AuthTokensKeychainManager.shared.saveToken(
                withKey: .accessToken, token: tokens.accessToken
            )
            AuthTokensKeychainManager.shared.saveToken(
                withKey: .refreshToken, token: tokens.refreshToken
            )
        }
    }
}

// MARK: - Email and Password
extension AuthViewModel {
    func loginWithEmailAndPassword(
        email: String, password: String
    )
        async -> Bool
    {
        let credintials = UserLoginCredintails(
            username: "", email: email, password: password
        )

        let result = await VoyagoService.shared.signInWithEmailAndPassword(
            withCredentials: credintials
        )

        switch result {
        case .success(let authResponse):
            VoyagoLogger.shared.logger.info(
                "Successfully logged in with email and password")

            self.userTokens = .init(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken)

            self.saveAuthTokens()
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error(
                "Failed to login with email and password: \(error)")
            return false
        }
    }

    // Registers a new user account
    // Only creates an account
    private func registerWithEmailAndPassword(
        username: String, email: String, password: String
    )
        async -> Bool
    {
        let credintials = UserLoginCredintails(
            username: "", email: email, password: password
        )

        let result = await VoyagoService.shared.signUpWithEmailAndPassword(
            withCredentials: credintials
        )

        switch result {
        case .success(let authResponse):
            VoyagoLogger.shared.logger.info(
                "Successfully Signed up with email and password"
            )

            self.userTokens = .init(
                accessToken: authResponse.session.accessToken,
                refreshToken: authResponse.session.refreshToken
            )

            self.saveAuthTokens()
            return true
        case .failure(let error):
            VoyagoLogger.shared.logger.error(
                "Failed to Sign up with email and password: \(error)"
            )

            return false
        }
    }

    func registerAndLoginWithEmailAndPassword(
        username: String, email: String, password: String
    )
        async -> Bool
    {
        // create account
        let registered = await self.registerWithEmailAndPassword(
            username: username, email: email, password: password
        )

        guard registered else { return false }

        // log in
        return await self.loginWithEmailAndPassword(
            email: email, password: password
        )
    }
}
