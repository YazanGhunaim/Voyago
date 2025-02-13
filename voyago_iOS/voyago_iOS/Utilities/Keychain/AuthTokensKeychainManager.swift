//
//  AuthTokensKeychainManager.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

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

                VoyagoLogger.shared.logger.info(
                    "Saving auth tokens with key \(key.rawValue) successful"
                )
            } catch KeychainError.duplicateEntry {
                VoyagoLogger.shared.logger.error(
                    "Saving auth token with key \(key.rawValue) failed: Duplicate entry"
                )
            } catch KeychainError.unknown(let status) {
                VoyagoLogger.shared.logger.error(
                    "Saving auth token failed: \(status)"
                )
            } catch _ {
                VoyagoLogger.shared.logger.error(
                    "Saving auth token failed: Unknown error"
                )
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
            VoyagoLogger.shared.logger.error(
                "Failed to get auth token with key \(key.rawValue)"
            )
            return nil
        }

        VoyagoLogger.shared.logger.error(
            "Succesffully got auth token with key \(key.rawValue)"
        )
        return token
    }
}
