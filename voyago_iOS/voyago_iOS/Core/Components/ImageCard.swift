//
//  ImageCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/4/25.
//

import Kingfisher
import SwiftUI

/// ImageCard view used throughout Voyago
struct ImageCard: View {
    let image: VoyagoImage

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // MARK: Image
            NavigationLink {
                ImageDetailsView(image: image)
            } label: {
                LoadedImage(image: image)
            }

            // MARK: Image metadata
            ImageMetaData(image: image)
                .padding(.horizontal, 8)
        }
        //        .clipShape(.rect(cornerRadius: 20))
        //                .border(.red)
    }
}

/// LoadedImage returns an image view from a URL
///
/// Uses KingFischer for image loading and caching
struct LoadedImage: View {
    let image: VoyagoImage

    var body: some View {
        KFImage(URL(string: image.regularUrl))
            .placeholder({ Rectangle().fill(Color.indigo).opacity(0.25) })
            .fade(duration: 1)
            .resizable()
//            .scaledToFill()  // extreme sus :o
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 10))
    }
}

/// Metadata about the image
struct ImageMetaData: View {
    let image: VoyagoImage

    var body: some View {
        HStack(alignment: .center) {
            Text(image.username)
                .font(.footnote)

            Spacer()

            Button {
                // TODO: sharing options
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    ImageCard(
        image: mockVoyagoImage
    )
}
