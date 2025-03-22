//
//  Users.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/16/25.
//

import Foundation

struct UserData: Codable {
    let name: String
    let username: String
}

struct UserOptions: Codable {
    let data: UserData
}
