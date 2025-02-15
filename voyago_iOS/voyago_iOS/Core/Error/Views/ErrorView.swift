//
//  ErrorView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/13/25.
//

import SwiftUI

/// View to indicate errors when they occur throughout the app lifecycle
struct ErrorView: View {
    let errorMessage: String
    let onReload: () -> Void

    init(
        errorMessage: String = "Looks like we have messed up behind the scenes. Please try again later.",
        onReload: @escaping () -> Void = {}
    ) {
        self.errorMessage = errorMessage
        self.onReload = onReload
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "tree.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(.indigo.opacity(0.5))

            Text("Yikes!")
                .font(.largeTitle.bold())

            Text(self.errorMessage)
                .multilineTextAlignment(.center)

            Button {
                self.onReload()
            } label: {
                Text("Reload page")
                    .foregroundStyle(.primary)
                    .padding(10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .buttonBorderShape(.roundedRectangle(radius: 30))
            .padding()
        }
        .padding()
    }
}

#Preview {
    ErrorView()
}
