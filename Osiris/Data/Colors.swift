//
//  Colors.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/18/24.
//

import SwiftUI

struct GlobalColorManager {
    static var accentColorMain: Color = Color("accent")
    static var accentColorSecondary: Color = Color(UIColor.systemGray4)
    static var accentColorTertiary: Color = Color(UIColor.systemGray)
    static var textColor: Color = Color(UIColor.label)
    static var backgroundColor: Color = Color(UIColor.systemBackground)
    static var backgroundAccent: Color = Color(UIColor.secondarySystemBackground)
    static var buttonColor: Color = accentColorMain
    static var buttonTextColor: Color = Color(UIColor.label)
    static var listBackgroundColor: Color = Color.white.opacity(0.5)
    static var cardBackgroundColor: Color = accentColorMain
    static var shadowColor: Color = Color.black.opacity(0)
}
