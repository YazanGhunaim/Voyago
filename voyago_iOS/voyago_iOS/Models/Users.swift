//
//  Users.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/16/25.
//

import Foundation

struct UserData: Codable {
    let username: String
}

struct UserOptions: Codable {
    let data: UserData
}

struct UserSignUpCredentials: Codable {
    let options: UserOptions
    let email: String
    let password: String
}

struct UserSignInCredentials: Codable {
    let email: String
    let password: String
}
