//
//  TabBarItemsViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import Foundation

enum TabBarItemsViewModel: Int, CaseIterable {
    case home = 0
    case visualize
    case profile

    var name: String {
        switch self {
        case .home:
            return "Home"
        case .visualize:
            return "Visualize"
        case .profile:
            return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .visualize:
            return "plus"
        case .profile:
            return "person.fill"
        }
    }
}
