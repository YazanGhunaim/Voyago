//
//  HomeView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        if self.viewModel.succeeded {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(self.viewModel.images, id: \.self) { image in
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .clipShape(.rect(cornerRadius: 5))
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Voyago")
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    HomeView()
}
