//
//  TravelBoardsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import SwiftUI

struct TravelBoardsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(1..<10) { num in
                    TravelBoardCard(
                        recommendationQuery: RecommendationQuery(
                            destination: "Czechia", days: num),
                        image: voyagoImageMock)
                }
            }
        }
    }
}

#Preview {
    TravelBoardsView()
}
