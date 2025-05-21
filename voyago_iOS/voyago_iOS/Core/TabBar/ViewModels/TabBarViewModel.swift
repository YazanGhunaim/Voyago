//
//  TabBarViewModel.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/18/25.
//

import Foundation

@Observable
class TabBarViewModel {
    var showSheet = true

    func toggleTabBar() {
        showSheet.toggle()
    }
}
