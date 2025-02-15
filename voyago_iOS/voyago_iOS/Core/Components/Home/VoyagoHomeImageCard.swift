//
//  VoyagoHomeImageCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

/// ImageCard view used throughout home view
struct VoyagoHomeImageCard: View {
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // MARK: Image
            NavigationLink {
                ImageDetailsView(image: image)
            } label: {
                VoyagoImageCard(image: image)
                    .scaledToFit()
            }

            // MARK: Image metadata
            VoyagoImageCardFooter(image: image)
                .padding(.horizontal, 8)
        }
    }
}

#Preview {
    VoyagoHomeImageCard(image: mockVoyagoImage)
}
