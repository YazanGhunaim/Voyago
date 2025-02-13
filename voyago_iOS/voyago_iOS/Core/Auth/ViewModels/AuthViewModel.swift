//
//  AuthViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

// TODO: Store tokens in keychain
@Observable
@MainActor
class AuthViewModel {
    var userTokens: UserTokens?
}

// MARK: - Email and Password
extension AuthViewModel {
    func loginWithEmailAndPassword(
        email: String, password: String
    )
        async
    {
        let credintials = UserCredintials(
            username: "", email: email, password: password
        )

        let result = await VoyagoService.shared.signInWithEmailAndPassword(
            withCredentials: credintials
        )

        switch result {
        case .success(let tokens):
            VoyagoLogger.shared.logger.info(
                "Successfully logged in with email and password")

            self.userTokens = .init(
                accessToken: tokens.session.accessToken,
                refreshToken: tokens.session.refreshToken)

        case .failure(let error):
            VoyagoLogger.shared.logger.error(
                "Failed to login with email and password: \(error)")
        }

    }

    func registerWithEmailAndPassword(
        username: String, email: String, password: String
    )
        async
    {

    }
}
