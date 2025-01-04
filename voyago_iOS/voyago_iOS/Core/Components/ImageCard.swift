//
//  ImageCard.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/4/25.
//

import Kingfisher
import SwiftUI

// TODO: Take in metadata
/// ImageCard view used throughout Voyago
struct ImageCard: View {
    let imageUrl: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: Image
            Image(imageUrl: self.imageUrl)

            // MARK: Image metadata
            ImageMetaData().padding(.horizontal, 8)
        }
        .clipShape(.rect(cornerRadius: 20))
    }
}

struct Image: View {
    let imageUrl: String

    var body: some View {
        KFImage(URL(string: self.imageUrl))
            .resizable()
            .scaledToFit()
    }
}

struct ImageMetaData: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Prague")
                .font(.headline)

            HStack {
                Text("Metadata")
            }
            .padding(.bottom, 15)
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ImageCard(
        imageUrl:
            "https://images.unsplash.com/photo-1503410781609-75b1d892dd28?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODIyMzV8MHwxfHNlYXJjaHwxfHxQcmFndWV8ZW58MHx8fHwxNzM2MDEzNDM3fDA&ixlib=rb-4.0.3&q=80&w=1080"
    )
}
