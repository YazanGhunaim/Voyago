//
//  HomeView.swift
//  Voyago
//
//  Created by Yazan Ghunaim on 11/3/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello")
            }
            .navigationTitle("Voyago")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
