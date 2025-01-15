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
    static var accent1: Color = Color("accent")
    static var gray1: Color = Color(UIColor.systemGray4)
    static var gray2: Color = Color(UIColor.systemGray3)
    static var gray3: Color = Color(UIColor.systemGray2)
    static var gray4: Color = Color(UIColor.systemGray)
    static var text1: Color = Color(UIColor.label)
    static var text2: Color = Color("accent")
    static var background1: Color = Color(UIColor.systemBackground)
    static var background2: Color = Color(UIColor.secondarySystemBackground)
    static var background3: Color = Color(UIColor.tertiarySystemBackground)
    static var button: Color = accent1
    static var white: Color = Color.white
    static var listBackground: Color = Color.white.opacity(0.5)
    static var cardBackground: Color = accent1
    static var shadowColor: Color = Color.black.opacity(0)
}
