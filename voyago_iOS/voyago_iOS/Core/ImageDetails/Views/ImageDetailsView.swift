//
//  ImageDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import SwiftUI
import Kingfisher

struct ImageDetailsView: View {
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Display the image using Kingfisher
            KFImage(URL(string: image.fullUrl))
                .placeholder {
                    ProgressView()  // Show a loading spinner while the image is loading
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                .shadow(radius: 4)

            // Metadata
            VStack(alignment: .leading, spacing: 8) {
                Text("Photographer: \(image.username)")
                    .font(.headline)

                if let unsplashProfile = image.unsplashProfile {
                    Link(
                        "View Profile on Unsplash",
                        destination: URL(string: unsplashProfile)!
                    )
                    .foregroundColor(.blue)
                    .underline()
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ImageDetailsView(image: voyagoImageMock)
}
