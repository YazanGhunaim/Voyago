//
//  VisualizingProgressView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

/// Custom progress bar
struct VisualizingProgressView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(1.5)

                Text("Visualizing your trip...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 4)
            )
        }
    }
}

#Preview {
    VisualizingProgressView()
}
