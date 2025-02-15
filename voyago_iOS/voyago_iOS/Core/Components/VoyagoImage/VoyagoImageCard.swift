//
//  ImageCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/4/25.
//

import Kingfisher
import SwiftUI

struct VoyagoImageCard<Content: View>: View {
    let image: VoyagoImage
    let placeholder: Content
    let fadeDuration: Double
    let cornerRadius: CGFloat
    let resolution: String  // TODO: Enum if switch is made

    init(
        image: VoyagoImage,
        @ViewBuilder placeholder: () -> Content = { Rectangle().fill(Color.indigo).opacity(0.25) },
        fadeDuration: Double = 1, cornerRadius: CGFloat = 10,
        resolution: String = "regular"
    ) {
        self.image = image
        self.placeholder = placeholder()
        self.fadeDuration = fadeDuration
        self.cornerRadius = cornerRadius
        self.resolution = resolution
    }

    private var stringURL: String {
        switch resolution {
        case "regular":
            return image.regularUrl
        case "full":
            return image.fullUrl
        case "small":
            return image.smallUrl
        case _:
            return image.regularUrl
        }
    }

    var body: some View {
        KFImage(URL(string: stringURL))
            .placeholder({ placeholder })
            .fade(duration: fadeDuration)
            .resizable()
            .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

#Preview {
    VoyagoImageCard(image: mockVoyagoImage)
}
