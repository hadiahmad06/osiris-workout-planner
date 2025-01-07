//
//  GlobalData.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/18/24.
//

import SwiftUI


struct AppInfo {
    static var version: String = "Alpha"
}


struct AssetsManager {
    static var logo: Image = Image(systemName: "figure.strengthtraining.traditional")
    static var accentColorMain: Color = Color("accent")
    static var accentColorSecondary: Color = Color(UIColor.systemGray4)
    static var accentColorTertiary: Color = Color(UIColor.systemGray)
    static var textColor: Color = Color(UIColor.label)
    static var textColorSecondary: Color = Color("accent")
    static var backgroundColor: Color = Color(UIColor.systemBackground)
    static var backgroundAccent: Color = Color(UIColor.secondarySystemBackground)
    static var buttonColor: Color = accentColorMain
    static var buttonTextColor: Color = Color.white
    static var listBackgroundColor: Color = Color.white.opacity(0.5)
    static var cardBackgroundColor: Color = accentColorMain
    static var shadowColor: Color = Color.black.opacity(0)
}
