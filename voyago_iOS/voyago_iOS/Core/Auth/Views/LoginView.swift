//
//  LoginView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/11/25.
//

import SwiftUI

// TODO: Fix keyboard covering text field
// TODO: Dismiss keyboard on screen tap
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @Environment(AuthViewModel.self) private var viewModel

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty  // TODO: naive af -> regex for email and password + display to user under input fields
    }

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: header
                AuthHeaderView(title1: "Hello.", title2: "Welcome back")

                // MARK: Input fields
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

                // TODO: Forgot password
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

                // MARK: Sign in
                Button {
                    Task { await viewModel.loginWithEmailAndPassword(email: email, password: password) }
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(formFilled ? Color(.systemIndigo) : Color(.systemIndigo).opacity(0.5))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                .disabled(!formFilled)

                Spacer()

                // MARK: Navigation to signup
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

//#Preview {
//    LoginView()
//}
