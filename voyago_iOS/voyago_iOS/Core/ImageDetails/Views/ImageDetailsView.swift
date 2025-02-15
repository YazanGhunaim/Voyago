//
//  ImageDetailsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/26/25.
//

import Kingfisher
import SwiftUI

/// Full page of image, displaying its metadata and other details
struct ImageDetailsView: View {
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // MARK: Image
            VoyagoImageCard(
                image: image,
                placeholder: { ProgressView() },
                resolution: "full"
            )
            .scaledToFit()

            // MARK: Metadata
            VoyagoImageMetaData(image: image)
        }
        .padding()
    }
}

#Preview {
    ImageDetailsView(image: mockVoyagoImage)
}
