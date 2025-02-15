//
//  AuthTokensKeychainManager.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

// TODO: are these operations expensive?
final class AuthTokensKeychainManager {
    static let shared = AuthTokensKeychainManager()

    private init() {}

    enum AuthTokenKey: String {
        case accessToken
        case refreshToken
    }

    func saveToken(withKey key: AuthTokenKey, token: String) {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            ]

            do {
                try KeychainManager.shared.saveData(query: query)
                VoyagoLogger.shared.logger.info("Saving auth tokens with key \(key.rawValue) successful")
            } catch KeychainError.duplicateEntry {
                VoyagoLogger.shared.logger.error("Saving auth token with key \(key.rawValue) failed: Duplicate entry")
            } catch KeychainError.unknown(let status) {
                VoyagoLogger.shared.logger.error("Saving auth token failed: \(status)")
            } catch _ {
                VoyagoLogger.shared.logger.error("Saving auth token failed: Unknown error")
            }
        }
    }

    func getToken(forKey key: AuthTokenKey) -> String? {
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

        VoyagoLogger.shared.logger.info("Succesffully got auth token with key \(key.rawValue)")
        return token
    }

    func updateToken(forKey key: AuthTokenKey, token: String) {
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
                VoyagoLogger.shared.logger.info("Successfully updated auth token \(key.rawValue)")
            } catch KeychainError.unknown(let status) {
                VoyagoLogger.shared.logger.error("Failed to update auth tokens with error: \(status)")
            } catch {
                VoyagoLogger.shared.logger.error("Should never happen but oh well...")
            }
        }
    }
}

extension AuthTokensKeychainManager {
    // saves auth tokens to keychain
    func saveAuthTokens(accessToken: String, refreshToken: String) {
        if authTokensExist() {
            AuthTokensKeychainManager.shared.updateToken(forKey: .accessToken, token: accessToken)
            AuthTokensKeychainManager.shared.updateToken(forKey: .refreshToken, token: refreshToken)
        } else {
            AuthTokensKeychainManager.shared.saveToken(withKey: .accessToken, token: accessToken)
            AuthTokensKeychainManager.shared.saveToken(withKey: .refreshToken, token: refreshToken)
        }
    }

    // Checks if user auth tokens already exist in keychain
    func authTokensExist() -> Bool {
        guard AuthTokensKeychainManager.shared.getToken(forKey: .accessToken) != nil else { return false }
        return true
    }
}
