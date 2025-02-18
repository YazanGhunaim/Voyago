//
//  ProfileSettingsView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var showDeleteAlert = false
    @State private var showSignOutAlert = false

    var body: some View {
        Form {
            Section(header: Text("User account")) {
                Button {
                    showSignOutAlert = true
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.blue)
                }
                .alert("Sign Out", isPresented: $showSignOutAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Sign Out", role: .destructive) {
                        Task { await authViewModel.signOut() }
                    }
                } message: {
                    Text("Are you sure you want to sign out?")
                }

                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
                .alert("Delete Account", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        Task { await authViewModel.deleteAccount() }
                    }
                } message: {
                    Text("Are you sure you want to delete your account? This action cannot be undone.")
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
}
