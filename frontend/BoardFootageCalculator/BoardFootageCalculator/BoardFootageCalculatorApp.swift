//
//  BoardFootageCalculatorApp.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//

import SwiftUI
import CoreText

@main
struct BoardFootageCalculatorApp: App {

    init() {
        guard let fontURL = Bundle.main.url(
            forResource: "Good Times Rg",
            withExtension: "otf"
        ) else {
            print("Could not find font")
            return
        }

        var error: Unmanaged<CFError>?

        let success = CTFontManagerRegisterFontsForURL(
            fontURL as CFURL,
            .process,
            &error
        )

        if success {
            print("Good Times registered")
        } else if let error {
            print("Font registration error:", error.takeRetainedValue())
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
