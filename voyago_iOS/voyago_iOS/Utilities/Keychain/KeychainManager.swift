//
//  KeychainManager.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
}

// Provides interface to interact with keychain
final class KeychainManager {
    static let shared = KeychainManager()

    private init() {}

    func saveData(query: [String: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }

    func getData(query: [String: Any]) -> String? {
        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func updateData(searchQuery: [String: Any], updateQuery: [String: Any]) throws {
        let status = SecItemUpdate(
            searchQuery as CFDictionary,
            updateQuery as CFDictionary
        )

        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }

    func deleteData(query: [String: Any]) -> Bool {
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    // might be useful:
    //    If you need to delete all Keychain items for your app,
    //    you can pass only { kSecClass: kSecClassGenericPassword }
    //    in the query, but be careful as this will remove all saved passwords.
}
