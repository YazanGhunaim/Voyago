//
//  NoTravelBoardsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct NoTravelBoardsView: View {
    @Binding var showingSheet: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("🤔")
                .scaledToFit()
                .font(.system(size: 100))

            Text("No travel boards yet.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(
                "Create a new one by clicking the plus button in the top right corner."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()

    }
}

#Preview {
    NoTravelBoardsView(showingSheet: .constant(false))
}
