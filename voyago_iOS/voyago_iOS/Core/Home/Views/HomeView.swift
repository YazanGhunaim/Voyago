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
        .onAppear {
            Task {
                let service = VoyagoService()
                let result = await service.fetchImages(for: "Prague", count: 10, page: 1)

                switch result {
                case .success(let images):
                    for image in images {
                        print("Image URL: \(image)")
                    }
                case .failure(let error):
                    print("Failed to fetch images: \(error)")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
