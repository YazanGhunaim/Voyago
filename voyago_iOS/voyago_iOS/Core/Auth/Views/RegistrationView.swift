//
//  RegistrationView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/11/25.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""

    @Environment(\.dismiss) var dismiss
    @Environment(AuthViewModel.self) private var viewModel

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack {
            // MARK: Header
            AuthHeaderView(title1: "Get started.", title2: "Create your account")

            VStack(spacing: 40) {
                VoyagoInputField(
                    imageName: "person", placeHolderText: "name",
                    text: $name)

                VoyagoInputField(
                    imageName: "person", placeHolderText: "Username",
                    text: $username)

                VoyagoInputField(
                    imageName: "envelope", placeHolderText: "Email",
                    text: $email)

                VoyagoInputField(
                    imageName: "lock", placeHolderText: "Password",
                    isSecureField: true, text: $password)
            }
            .padding(32)

            Button {
                Task {
                    await viewModel.registerWithEmailAndPassword(
                        name: name, username: username, email: email, password: password)
                }
            } label: {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(formFilled ? .indigo : .indigo.opacity(0.5))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            .disabled(!formFilled)

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)

                    Text("Sign in")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.indigo)
            .padding(.bottom, 32)

        }
        .ignoresSafeArea()
    }
}

#Preview {
    RegistrationView()
}
