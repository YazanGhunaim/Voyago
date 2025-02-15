//
//  TravelBoardPlacesToVisitView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardPlacesToVisitView: View {
    let recommendations: [SightRecommendation]

    var body: some View {
        ZStack {
            // MARK: Section title
            VStack(alignment: .leading, spacing: 15) {
                Text("Places to visit")
                    .bold()

                ForEach(recommendations, id: \.id) { recommendation in
                    // MARK: sight recommendation card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(recommendation.sight)")
                            .font(.headline)

                        Text("\(recommendation.brief)")

                        // MARK: picture?
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemPurple).opacity(0.1))
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        }
        .padding()
    }
}
