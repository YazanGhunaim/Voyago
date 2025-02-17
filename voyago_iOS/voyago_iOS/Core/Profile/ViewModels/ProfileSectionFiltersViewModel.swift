//
//  ProfileSectionFiltersViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import Foundation

enum ProfileSectionFiltersViewModel: Int, CaseIterable {
    case posts
    case boards
    case collections

    var title: String {
        switch self {
        case .posts:
            return "Posts"
        case .collections:
            return "Collections"
        case .boards:
            return "Boards"
        }
    }
}
