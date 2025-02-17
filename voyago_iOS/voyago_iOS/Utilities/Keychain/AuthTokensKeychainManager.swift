//
//  AuthTokensKeychainManager.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

final class AuthTokensKeychainManager {
    static let shared = AuthTokensKeychainManager()

    // in memory cache
    private var accessToken: String?
    private var refreshToken: String?

    private enum AuthTokenKey: String {
        case accessToken
        case refreshToken
    }

    private init() {
        self.accessToken = self.getToken(forKey: .accessToken)
        self.refreshToken = self.getToken(forKey: .refreshToken)
    }

    func getAccessToken() -> String? {
        if let accessToken = self.accessToken {
            return accessToken
        }

        self.accessToken = self.getToken(forKey: .accessToken)
        return self.accessToken
    }

    func getRefreshToken() -> String? {
        if let refreshToken = self.refreshToken {
            return refreshToken
        }

        self.refreshToken = self.getToken(forKey: .refreshToken)
        return self.refreshToken
    }

    // saves auth tokens to keychain
    func saveAuthTokens(accessToken: String, refreshToken: String) {
        // workaround... only write to keychain if refreshtoken used
        guard accessToken != self.accessToken || refreshToken != self.refreshToken else { return }

        if authTokensExist() {
            VoyagoLogger.shared.logger.debug("Updating user tokens")
            AuthTokensKeychainManager.shared.updateToken(forKey: .accessToken, token: accessToken)
            AuthTokensKeychainManager.shared.updateToken(forKey: .refreshToken, token: refreshToken)
        } else {
            VoyagoLogger.shared.logger.debug("Saving user tokens")
            AuthTokensKeychainManager.shared.saveToken(withKey: .accessToken, token: accessToken)
            AuthTokensKeychainManager.shared.saveToken(withKey: .refreshToken, token: refreshToken)
        }

        // update in mem cache
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    // Checks if user auth tokens already exist in keychain
    private func authTokensExist() -> Bool {
        guard AuthTokensKeychainManager.shared.getToken(forKey: .accessToken) != nil else { return false }
        return true
    }
}

extension AuthTokensKeychainManager {
    private func saveToken(withKey key: AuthTokenKey, token: String) {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            ]

            do {
                try KeychainManager.shared.saveData(query: query)
                VoyagoLogger.shared.logger.debug("Saving auth tokens with key \(key.rawValue) successful")
            } catch KeychainError.duplicateEntry {
                VoyagoLogger.shared.logger.error("Saving auth token with key \(key.rawValue) failed: Duplicate entry")
            } catch KeychainError.unknown(let status) {
                VoyagoLogger.shared.logger.error("Saving auth token failed: \(status)")
            } catch _ {
                VoyagoLogger.shared.logger.error("Saving auth token failed: Unknown error")
            }
        }
    }

    private func updateToken(forKey key: AuthTokenKey, token: String) {
        if let data = token.data(using: .utf8) {
            let searchQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
            ]

            let updateQuery: [String: Any] = [
                kSecValueData as String: data
            ]

            do {
                try KeychainManager.shared.updateData(searchQuery: searchQuery, updateQuery: updateQuery)
                VoyagoLogger.shared.logger.debug("Successfully updated auth token \(key.rawValue)")
            } catch KeychainError.unknown(let status) {
                VoyagoLogger.shared.logger.error("Failed to update auth tokens with error: \(status)")
            } catch {
                VoyagoLogger.shared.logger.error("Should never happen but oh well...")
            }
        }
    }

    private func getToken(forKey key: AuthTokenKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        guard let token = KeychainManager.shared.getData(query: query) else {
            VoyagoLogger.shared.logger.error("Failed to get auth token with key \(key.rawValue)")
            return nil
        }

        VoyagoLogger.shared.logger.debug("Succesffully got auth token with key \(key.rawValue)")
        return token
    }
}
