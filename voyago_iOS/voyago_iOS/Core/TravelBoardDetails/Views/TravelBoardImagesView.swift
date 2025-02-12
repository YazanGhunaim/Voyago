//
//  TravelBoardImagesView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardImagesView: View {
    let images: [String: [VoyagoImage]]

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Sights")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(
                        images.keys.sorted(), id: \.self
                    ) {
                        sight in
                        ForEach(
                            images[sight] ?? [],
                            id: \.id
                        ) {
                            image in
                            VoyagoImageCard(image: image)
                                .frame(height: 250)
                                .scaledToFit()
                        }
                    }
                    .containerRelativeFrame(
                        .horizontal, count: 1, spacing: 0
                    )

                }
                .scrollTargetLayout()
            }
            .contentMargins(20, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}
