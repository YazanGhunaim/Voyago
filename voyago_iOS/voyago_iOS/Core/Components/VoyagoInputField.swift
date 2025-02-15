//
//  VoyagoInputField.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/11/25.
//

import SwiftUI

struct VoyagoInputField: View {
    let imageName: String
    let placeHolderText: String
    var isSecureField: Bool? = false
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))

                if isSecureField ?? false {
                    SecureField(placeHolderText, text: $text)
                } else {
                    TextField(placeHolderText, text: $text)
                }
            }

            Divider()
                .background(Color(.darkGray))
        }
    }
}

#Preview {
    VoyagoInputField(
        imageName: "envelope", placeHolderText: "Email", isSecureField: false,
        text: .constant(""))
}
