//
//  DebugModels.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/29.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public struct DebugModels {
    public static let colorBackground = DevToolModel("General", "Colors", "Background", Color.orange)
    public static let colorTint = DevToolModel("General", "Colors", "Tint", Color.yellow)
    public static let colorButtonText = DevToolModel("General", "Colors", "Button Text", Color.purple)

    // Tweaks work *great* with numbers, you just need to tell the compiler
    // what kind of number you're using (Int, CGFloat, or Double)
    public static let fontSizeText1 = DevToolModel("Text", "Font Sizes", "title", 32)
    public static let fontSizeText2 = DevToolModel("Text", "Font Sizes", "body", 18)

    // If the tweak is for a number, you can optionally add default / min / max / stepSize options to restrict the values.
    // Maybe you've got a number that must be non-negative, for example:
    public static let horizontalMargins = DevToolModel("General", "Layout", "H. Margins", 16, minValue: 0)
    public static let verticalMargins = DevToolModel("General", "Layout", "V. Margins", 16, minValue: 0)

    public static let colorText1 = DevToolModel("Text", "Color", "text-1", Color.black)
    public static let colorText2 = DevToolModel("Text", "Color", "text-2", Color.blue)

    public static let title = DevToolModel("Text", "Text", "Title", options: ["SwiftTweaks", "Welcome!", "Example"], defaultValue: "Example")
    public static let subtitle = DevToolModel("Text", "Text", "Subtitle", "Subtitle")

    // Tweaks are often used in combination with each other, so we have some templates available for ease-of-use:
//    public static let buttonAnimation = SpringAnimationTweakTemplate("Animation", "Button Animation", duration: 0.5) // Note: "duration" is optional, if you don't provide it, there's a sensible default!

    // You can even run your own code from a tweak! More on this in this example's ViewController.swift file
//    public static let actionPrintToConsole = DevToolModel<ModelAction>("General", "Actions", "Print to console")
    
    /*
    Seriously, SpringAnimationTweakTemplate is *THE BEST* - here's what the equivalent would be if you were to make that by hand:

    public static let animationDuration = Tweak<Double>("Animation", "Button Animation", "Duration", defaultValue: 0.5, min: 0.0)
    public static let animationDelay = Tweak<Double>("Animation", "Button Animation", "Delay", defaultValue: 0.0, min: 0.0, max: 1.0)
    public static let animationDamping = Tweak<CGFloat>("Animation", "Button Animation", "Damping", defaultValue: 0.7, min: 0.0, max: 1.0)
    public static let animationVelocity = Tweak<CGFloat>("Animation", "Button Animation", "Initial V.", 0.0)

    */

    public static let featureFlagMainScreenHelperText = DevToolModel("Feature Flags", "Main Screen", "Show Body Text", true)

    public static let defaultStore: DevToolStore = {
        let allModels: [ModelClusterType] = [
            colorBackground,
            colorTint,
            colorButtonText,
            horizontalMargins,
            verticalMargins,

            colorText1,
            colorText2,
            title,
            subtitle,

            fontSizeText1,
            fontSizeText2,

//            actionPrintToConsole,
            
            featureFlagMainScreenHelperText
        ]

        // Since SwiftTweaks is a dynamic library, you'll need to determine whether tweaks are enabled.
        // Try using the DEBUG flag (add "-D DEBUG" to "Other Swift Flags" in your project's Build Settings).
        // Below, we'll use TweakDebug.isActive, which is a shortcut to check the DEBUG flag.

        return DevToolStore(
            models: allModels,
            storeName: "ExampleTweaks"     // NOTE: You can omit the `storeName` parameter if you only have one TweakLibraryType in your application.
        )
    }()
}
