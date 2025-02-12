//
//  TravelBoardSectionDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct TravelBoardSectionDetailsView: View {
    let dailyPlan: [DayPlan]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Plan")
                    .bold()

                VStack(alignment: .leading, spacing: 15) {
                    // MARK: Daily plans
                    ForEach(dailyPlan, id: \.hashValue) { plan in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Day: \(plan.day)")
                                .font(.headline)

                            Text("\(plan.plan)")

                            // MARK: picture?
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    Color(.systemPurple).opacity(0.1))
                        }
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
        .padding(.horizontal)
    }
}
