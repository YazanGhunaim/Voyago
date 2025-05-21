//
//  TravelBoardPlanDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardPlanDetailsView: View {
    let dailyPlan: [DayPlan]

    var body: some View {
        
            ScrollView(.horizontal) {
                HStack {
                    ForEach(dailyPlan, id: \.hashValue) { plan in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Day \(plan.day):")
                                .font(.headline)
                            
                            Text(plan.plan)
                            
                            // MARK: picture?
                        }
                        .padding()
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.thinMaterial)
                                .stroke(.primary, lineWidth: 0.5)
                                .shadow(color: .primary, radius: 1)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(20, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    
}

//#Preview {
//    TravelBoardPlanDetailsView(dailyPlan: mockTravelBoard.plan)
//}
