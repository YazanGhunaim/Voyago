//
//  voyago_iOSApp.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 12/25/24.
//

import SwiftUI

/// Main entry point to the app
@main
struct voyago_iOSApp: App {
    @State private var genTravelBoardFormViewModel =
        GenTravelBoardFormViewModel()

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(genTravelBoardFormViewModel)
        }
    }
}
