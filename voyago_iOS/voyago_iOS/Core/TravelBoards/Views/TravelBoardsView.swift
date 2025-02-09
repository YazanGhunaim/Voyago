//
//  TravelBoardsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/9/25.
//

import SwiftUI

struct TravelBoardsView: View {
    @State private var showingSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(1..<10) { num in
                        TravelBoardCard(
                            recommendationQuery: RecommendationQuery(
                                destination: "Czech Republic", days: num),
                            image: voyagoImageMock)
                    }
                }
            }
            .navigationTitle("Travel boards")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            showingSheet.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                    .tint(.primary)
                }
            }
            .sheet(isPresented: $showingSheet) {
                GenTravelBoardForm()
            }
        }
    }
}

#Preview {
    TravelBoardsView()
}
