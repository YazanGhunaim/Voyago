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
        VStack(alignment: .leading, spacing: 5) {
            // MARK: Image
            LoadedImage(imageUrl: self.imageUrl)

            // MARK: Image metadata
            ImageMetaData().padding(.horizontal, 8)
        }
        //        .clipShape(.rect(cornerRadius: 20))
        //                .border(.red)
    }
}

struct LoadedImage: View {
    let imageUrl: String

    var body: some View {
        KFImage(URL(string: self.imageUrl))
            .placeholder({ Rectangle().fill(Color.indigo).opacity(0.25) })
            .fade(duration: 1)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 10))
    }
}

struct ImageMetaData: View {
    var body: some View {
        HStack(alignment: .center) {
            Text("Prague")
                .font(.headline)

            Spacer()

            Button {
                // TODO: Go to metadata view
            } label: {
                Image(systemName: "ellipsis")

            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    ImageCard(
        imageUrl:
            "https://images.unsplash.com/photo-1503410781609-75b1d892dd28?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODIyMzV8MHwxfHNlYXJjaHwxfHxQcmFndWV8ZW58MHx8fHwxNzM2MDEzNDM3fDA&ixlib=rb-4.0.3&q=80&w=1080"
    )
}
