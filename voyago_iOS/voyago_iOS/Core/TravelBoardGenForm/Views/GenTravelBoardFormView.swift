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

    @State private var destination: String = ""
    @State private var numberOfDays: Int = 1

    @Environment(GenTravelBoardFormViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            // MARK: Form
            TravelBoardQueryForm(
                destination: $destination,
                numberOfDays: $numberOfDays,
                viewModel: viewModel
            )
        }
    }
}

struct TravelBoardQueryForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var destination: String
    @Binding var numberOfDays: Int

    let viewModel: GenTravelBoardFormViewModel

    var formNotFilled: Bool {
        destination.isEmpty
    }

    var numberOfDaysText: String {
        "\(self.numberOfDays)" + (self.numberOfDays > 1 ? " days" : " day")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: Destination Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Where to?")
                    .font(.headline)
                TextField("Enter your destination", text: $destination)
            }

            Divider()

            // MARK: Duration Input
            VStack(alignment: .leading, spacing: 8) {
                Text("How long will you be staying?")
                    .font(.headline)
                Stepper(value: $numberOfDays, in: 1...14) {
                    Text(numberOfDaysText)
                        .font(.body)
                }
            }

            // MARK: Submit Button
            Button {
                Task {
                    await viewModel.getGeneratedTravelBoard(
                        query: RecommendationQuery(
                            destination: destination, days: numberOfDays))
                }
                dismiss()
            } label: {
                Text("Visualize")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        self.formNotFilled ? Color.gray : Color.indigo
                    )
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .disabled(self.formNotFilled)

            //            NavigationLink {
            //                switch viewModel.viewState {
            //                case .Loading:
            //                    VisualizingProgressView()
            //                case .Success:
            //                    Text("Hello")
            //                case .Failure(_):
            //                    ErrorView()
            //                }
            //            } label: {
            //
            //            }

            Spacer()
        }
        .padding()
        .navigationTitle("Visualize Your Trip")
    }
}

//#Preview {
//    GenTravelBoardFormView()
//}
