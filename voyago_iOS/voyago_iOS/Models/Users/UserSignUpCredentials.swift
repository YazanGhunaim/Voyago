//
//  UserSignUpCredentials.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 3/16/25.
//

import Foundation

struct UserSignUpCredentials: Codable {
    let options: UserOptions
    let email: String
    let password: String
}
