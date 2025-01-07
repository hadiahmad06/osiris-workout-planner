//
//  PlanRowView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/3/25.
//

import SwiftUI

struct PlanRowView: View {
    let imageName: String
    let text: String
    
    var body: some View {
            HStack {
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(AssetsManager.accentColorMain)
                Spacer()
                Text(text)
                    .font(.headline)
                    .foregroundColor(AssetsManager.textColor)
                
            }
            .frame(maxWidth: 200)
            .padding(8)
            .background(AssetsManager.accentColorSecondary)
            .cornerRadius(8)
//        }
    }
}
