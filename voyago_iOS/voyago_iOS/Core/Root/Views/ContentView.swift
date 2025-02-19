//
//  ContentView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/13/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    //    @State private var authViewModel = AuthViewModel()
    //    @State private var tabBarViewModel = TabBarViewModel()

    var body: some View {
        Group {
            switch authViewModel.userSessionState {
            case .loggedIn:
                MainTabView()
            case .loggedOut:
                LoginView()
            case .none:
                ProgressView()
            }
        }
        //        .environment(authViewModel)
        //        .environment(tabBarViewModel)
    }
}

#Preview {
    ContentView()
}
