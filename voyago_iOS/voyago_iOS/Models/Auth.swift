//
//  User.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import Foundation

struct UserLoginCredintails: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let session: UserTokens
}
