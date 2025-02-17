//
//  MainTabView.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

struct MainTabView: View {
    //    @State private var showingSheet = false
    @State private var selectedItem = 1
    //    @State private var oldSelectedItem = 1

    var body: some View {
        TabView(selection: $selectedItem) {
            Tab("", systemImage: "house.fill", value: 1) {
                HomeView()
            }

            Tab("", systemImage: "plus", value: 2) {
                VisualizeTravelBoardView()
            }

            Tab("", systemImage: "person.fill", value: 3) {
                ProfileView()
            }
        }
        .tint(.indigo)
        //        .onChange(of: selectedItem) { old, new in
        //            if selectedItem == 2 {
        //                showingSheet.toggle()
        //            } else {
        //                oldSelectedItem = new
        //            }
        //        }
        //        .sheet(isPresented: $showingSheet) {
        //            selectedItem = oldSelectedItem
        //        } content: {
        //            VisualizeTravelBoardView()
        //                .presentationDetents([.medium])
        //        }
    }
}

#Preview {
    MainTabView()
}
