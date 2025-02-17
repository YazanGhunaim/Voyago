//
//  ProfileImageView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import Kingfisher
import SwiftUI

struct ProfileImageView: View {
    let imageURL: String =
        "https://media.licdn.com/dms/image/v2/D4E03AQH8rhQX1r99wg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1727593476138?e=2147483647&v=beta&t=ErQ6iaTgn6rJXvOF1jZs2YwWb0BL5s2ya4yDsRz8HyM"

    var body: some View {
        KFImage(URL(string: imageURL))
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
    }
}

#Preview {
    ProfileImageView()
}
