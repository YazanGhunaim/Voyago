//
//  MainTabView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedItem = 0
    @State private var isTabBarHidden = false

    @Environment(TabBarViewModel.self) private var viewModel

    var body: some View {
        TabView(selection: $selectedItem) {
            Group {
                HomeView()
                    .tag(0)

                EmptyView()  // sheet for visualization form... check customTabBar
                    .tag(1)

                ProfileView()
                    .tag(2)
            }
            .toolbarBackground(.hidden, for: .tabBar)
        }
        .tint(.indigo)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(alignment: .bottom) {
            if viewModel.showSheet {
                CustomTabBar(selectedItem: $selectedItem)
            }
        }
    }
}

#Preview {
    MainTabView()
}
