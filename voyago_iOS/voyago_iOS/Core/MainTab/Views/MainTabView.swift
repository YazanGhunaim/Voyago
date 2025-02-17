//
//  MainTabView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("", systemImage: "house.fill") {
                HomeView()
            }

            Tab("", systemImage: "wand.and.stars") {
                TravelBoardsView()
            }

            Tab("", systemImage: "person.fill") {
                ProfileView()
            }
        }
        .tint(.indigo)
    }
}

#Preview {
    MainTabView()
}
