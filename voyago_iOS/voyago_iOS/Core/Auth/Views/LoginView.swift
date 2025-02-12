//
//  LoginView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/11/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    //    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: header
                AuthHeaderView(title1: "Hello.", title2: "Welcome back")

                VStack(spacing: 40) {
                    VoyagoInputField(
                        imageName: "envelope", placeHolderText: "Email",
                        text: $email
                    )

                    VoyagoInputField(
                        imageName: "lock", placeHolderText: "Password",
                        isSecureField: true, text: $password
                    )
                }
                .padding(.horizontal, 32)
                .padding(.top, 44)

                HStack {
                    Spacer()

                    NavigationLink {
                        Text("Reset Password View..")
                    } label: {
                        Text("Forgot Password?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemIndigo))
                            .padding(.top)
                            .padding(.trailing, 24)
                    }

                }

                Button {
                    //                viewModel.login(withEmail: email, password: password)
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemIndigo))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)

                Spacer()

                NavigationLink {
                    RegistrationView()
                        .toolbar(.hidden, for: .navigationBar)
                } label: {
                    HStack {
                        Text("Dont have an account?")
                            .font(.footnote)

                        Text("Sign Up")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
                .foregroundStyle(Color(.systemIndigo))
            }
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    LoginView()
}
