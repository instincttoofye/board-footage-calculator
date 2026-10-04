//
//  BoardFootageCalculatorApp.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//

import SwiftUI

@main
struct BoardFootageCalculatorApp: App {

    init() {
        FontManager.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 600,
                    idealWidth: 800,
                    minHeight: 700,
                    idealHeight: 1000
                )
        }
        .defaultSize(width: 800, height: 1000)
    }
}
