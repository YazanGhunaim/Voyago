//
//  TravelBoardDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/28/25.
//

import Kingfisher
import SwiftUI

struct TravelBoardDetailsView: View {
    let travelBoard: GeneratedTravelBoard

    @Environment(TabBarViewModel.self) private var tabBarVM

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                // MARK: TravelBoard section details
                VStack(alignment: .leading, spacing: 0) {
                    Text("Plan:")
                        .padding(.horizontal)
                        .font(.title)

                    TravelBoardPlanDetailsView(dailyPlan: travelBoard.plan)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Sights:")
                        .padding(.horizontal)
                        .font(.title)
                    // MARK: Places to visit
                    TravelBoardSightDetailsView(board: travelBoard)
                }
            }
            .navigationTitle("Your trip to \(travelBoard.recommendationQuery.destination)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            tabBarVM.toggleTabBar()
        }
        .onDisappear {
            tabBarVM.toggleTabBar()
        }
    }
}

#Preview {
    TravelBoardDetailsView(travelBoard: mockTravelBoard)
}
