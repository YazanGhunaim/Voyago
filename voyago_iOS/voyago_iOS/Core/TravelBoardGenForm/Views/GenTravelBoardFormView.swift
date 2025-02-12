//
//  GenTravelBoardFormView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

/// Form View for itinerary user input
struct GenTravelBoardFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(GenTravelBoardFormViewModel.self) private var viewModel

    @State private var destination: String = ""
    @State private var numberOfDays: Int = 1

    var formNotFilled: Bool {
        destination.isEmpty
    }
    var numberOfDaysText: String {
        "\(self.numberOfDays)" + (self.numberOfDays > 1 ? " days" : " day")
    }

    var body: some View {
        NavigationStack {
            // MARK: Form
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
                    Task { await submit() }
                } label: {
                    Text("Visualize")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            self.formNotFilled ? Color.gray : Color.indigo
                        )
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

extension GenTravelBoardFormView {

    func submit() async {
        let query = RecommendationQuery(
            destination: destination, days: numberOfDays
        )
        await viewModel.getGeneratedTravelBoard(query: query)
        dismiss()
    }
}

//#Preview {
//    GenTravelBoardFormView()
//}
