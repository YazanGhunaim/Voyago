//
//  ProfileView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedFilter: ProfileSectionFiltersViewModel = .collections
    @Namespace var animation

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                profileHeader
                    .padding(.bottom)

                VStack(spacing: 25) {
                    profileStats

                    actionButtons
                }
                .padding()

                sectionFiltersBar

                sectionContent

                Spacer()
            }
            .ignoresSafeArea(.all)
        }
    }
}

extension ProfileView {
    var profileHeader: some View {
        ZStack {
            userHeaderDetails

            ProfileImageView()
                .frame(width: 130, height: 130)
                .background(Circle().stroke(.secondary, lineWidth: 4))
                .offset(y: 120)
        }
    }

    var userHeaderDetails: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack { Spacer() }

            Text("Yazan Ghunaim")
                .font(.largeTitle.bold())

            HStack {
                Image(systemName: "mappin")

                Text("Prague, Czech Republic")
                    .font(.title2)
            }
            .foregroundStyle(.secondary)
        }
        .frame(height: 280)
        .padding()
        .foregroundStyle(.white)
        .background(.indigo)
        .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight]))
    }

    var profileStats: some View {
        HStack {
            VStack(alignment: .center) {
                Text("450")
                Text("posts")
            }

            Spacer()

            VStack(alignment: .center) {
                Text("1020")
                Text("followers")
            }

            Spacer()

            VStack(alignment: .center) {
                Text("2030")
                Text("following")
            }
        }
        .frame(maxWidth: 300)
        .bold()
    }

    var actionButtons: some View {
        HStack {
            NavigationLink {
                ProfileSettingsView()
            } label: {
                HStack {
                    Image(systemName: "gearshape")

                    Text("settings")
                }
                .font(.subheadline.bold())
                .frame(width: 125, height: 40)
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundStyle(.white)
            }

            Button {
                // TODO: action
            } label: {
                HStack {
                    Image(systemName: "pencil")

                    Text("edit profile")
                }
                .font(.subheadline.bold())
                .frame(width: 125, height: 40)
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundStyle(.white)
            }
        }
    }

    var sectionFiltersBar: some View {
        HStack {
            ForEach(ProfileSectionFiltersViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)

                    if selectedFilter == item {
                        Capsule()
                            .foregroundStyle(.indigo)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedFilter = item
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }

    var sectionContent: some View {
        EmptyView()
    }
}

#Preview {
    ProfileView()
}
