//
//  HomeView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

struct HomeView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(1..<20) { _ in
                        Rectangle()
                            .fill(.indigo)
                            .frame(width: 180, height: 250)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Voyago")
        }
    }
}

#Preview {
    HomeView()
}
