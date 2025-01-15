//
//  SettingsToggleView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct SettingsToggleView: View {
    let imageName: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(color)
                
            Text(title)
                .font(.subheadline)
                .foregroundColor(AssetsManager.text1)
        }
    }
}
