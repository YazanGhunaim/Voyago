//
//  VisualizeTravelBoardFormView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import SwiftUI

struct VisualizeTravelBoardFormView: View {
    @State private var destination: String = ""
    @State private var numberOfDays: Int = 1

    @Bindable var viewModel: VisualizeTravelBoardViewModel

    var formNotFilled: Bool {
        destination.isEmpty
    }

    var numberOfDaysText: String {
        "\(self.numberOfDays)" + (self.numberOfDays > 1 ? " days" : " day")
    }

    func visualize() async {
        let query = RecommendationQuery(destination: destination, days: numberOfDays)
        await viewModel.getGeneratedTravelBoard(query: query)
        //        dismiss()
    }
}

extension VisualizeTravelBoardFormView {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: Destination Input
                VoyagoInputField(
                    imageName: "sun.and.horizon.fill",
                    placeHolderText: "Where to?",
                    text: $destination
                )

                // MARK: Duration Input
                VStack(alignment: .leading, spacing: 10) {
                    Text("How long will you be staying?")
                        .font(.headline)

                    Stepper(value: $numberOfDays, in: 1...14) {
                        Text(numberOfDaysText)
                            .font(.body)
                    }
                }

                // MARK: Submit Button
                Button {
                    Task { await visualize() }
                } label: {
                    Text("Visualize")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(self.formNotFilled ? Color.gray : Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .disabled(self.formNotFilled)

                Spacer()
            }
            .padding()
            .navigationTitle("Visualize Your Trip")
        }
    }
}

//#Preview {
//    VisualizeTravelBoardFormView()
//}
