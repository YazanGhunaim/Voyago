//
//  UserTokens.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

struct UserTokens: Codable {
    let accessToken: String
    let refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
