//
//  VoyagoImageCardFooter.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/12/25.
//

import SwiftUI

struct VoyagoImageCardFooter: View {
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
    VoyagoImageCardFooter(image: mockVoyagoImage)
}
