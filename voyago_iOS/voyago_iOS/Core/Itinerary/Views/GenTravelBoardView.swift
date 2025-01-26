//
//  GenTravelBoardView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

struct GenTravelBoardView: View {
    @State private var viewmodel = GenTravelBoardViewModel()
    @State private var destination: String = ""
    @State private var numberOfDays: Int = 1

    private var numberOfDaysText: String {
        "\(self.numberOfDays)" + (self.numberOfDays > 1 ? " days" : " day")
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: User input
                Section(header: Text("Where to?")) {
                    TextField("Prague", text: $destination)
                }
                Section(header: Text("How long?")) {
                    Stepper(
                        self.numberOfDaysText, value: $numberOfDays,
                        in: 1...14)
                }

                // MARK: Submit
                Section {
                    Button {
                        let query = RecommendationQuery(
                            destination: self.destination,
                            days: self.numberOfDays)
                        Task {
                            await self.viewmodel.getGeneratedTravelBoard(
                                query: query)
                        }
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Visualize your trip")
        }
    }
}

#Preview {
    GenTravelBoardView()
}
