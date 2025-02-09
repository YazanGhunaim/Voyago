//
//  GenTravelBoardForm.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI

/// Form View for itinerary user input
struct GenTravelBoardForm: View {
    @Environment(\.dismiss) var dismiss

    @State private var destination: String = ""
    @State private var numberOfDays: Int = 1

    var body: some View {
        NavigationStack {
            // MARK: Form
            GenTravelBoardFormView(
                destination: $destination,
                numberOfDays: $numberOfDays
            )
            .toolbar {  // MARK: Dismiss sheet
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
            }
        }

    }
}

struct GenTravelBoardFormView: View {
    @Binding var destination: String
    @Binding var numberOfDays: Int

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
                Text("How many days?")
                    .font(.headline)
                Stepper(value: $numberOfDays, in: 1...14) {
                    Text(numberOfDaysText)
                        .font(.body)
                }
            }

            // MARK: Submit Button
            NavigationLink {
                GenTravelBoardView(
                    destination: self.destination, numOfDays: self.numberOfDays)
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

            Spacer()
        }
        .padding()
        .navigationTitle("Visualize Your Trip")
    }
}

#Preview {
    GenTravelBoardForm()
}
