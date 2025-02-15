//
//  VoyagoImageMetaData.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct VoyagoImageMetaData: View {
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: Username
            Text("Photographer: \(image.username)")
                .font(.headline)

            // MARK: Unsplash Link
            if let unsplashProfile = image.unsplashProfile {
                Link("View Profile on Unsplash", destination: URL(string: unsplashProfile)!)
                    .foregroundColor(.blue)
                    .underline()
            }
        }
    }
}

#Preview {
    VoyagoImageMetaData(image: mockVoyagoImage)
}
