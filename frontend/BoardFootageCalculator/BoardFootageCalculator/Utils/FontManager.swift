//
//  FontManager.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//


import Foundation
import CoreText

enum FontManager {

    static func registerFonts() {
        registerFont(
            resource: "Good Times Rg",
            extension: "otf"
        )
    }

    private static func registerFont(
        resource: String,
        extension fileExtension: String
    ) {
        guard let fontURL = Bundle.main.url(
            forResource: resource,
            withExtension: fileExtension
        ) else {
            print("Could not find font: \(resource).\(fileExtension)")
            return
        }

        var error: Unmanaged<CFError>?

        let success = CTFontManagerRegisterFontsForURL(
            fontURL as CFURL,
            .process,
            &error
        )

        if success {
            print("Registered font: \(resource)")
        } else if let error {
            print(
                "Failed to register font:",
                error.takeRetainedValue()
            )
        }
    }
}