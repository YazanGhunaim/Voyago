//
//  TabBarView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

struct TabBarView: View {
    //    @State private var genTravelBoardFormViewModel =
    //        GenTravelBoardFormViewModel()

    var body: some View {
        TabView {
            Tab("", systemImage: "house.fill") {
                HomeView()
            }

            Tab("", systemImage: "wand.and.stars") {
                TravelBoardsView()
            }

            Tab("", systemImage: "person.fill") {
                Text("Profile View")
            }
        }
        //        .environment(genTravelBoardFormViewModel)  // for previews TODO: remove later
        .tint(.indigo)
    }
}

#Preview {
    TabBarView()
}
