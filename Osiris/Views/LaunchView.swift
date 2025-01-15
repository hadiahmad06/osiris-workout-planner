//
//  LaunchView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/19/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var progress: Double = 0
    private let maxWidth: CGFloat = 150
    private let height: CGFloat = 8
    private let cornerRadius: CGFloat = 10
    private let duration: Double = 2 // Duration in seconds
    private func startLoading() {
            // Reset progress
            progress = 0
            
            // Animate to full
            withAnimation(.easeInOut(duration: duration)) {
                progress = 1.0
            }
        }
    var body: some View {
        VStack{
            Spacer()
            AssetsManager.logo
                .font(.system(size: 120))
                .foregroundColor(AssetsManager.accent1)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AssetsManager.gray1)
                    .frame(width: maxWidth, height: height)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AssetsManager.accent1)
                    .frame(width: maxWidth * progress, height: height)
                    .animation(.easeInOut(duration: duration), value: progress)
            }
            .onAppear {
                startLoading()
            }
            Spacer()
            
            Text(AppInfo.version)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(AssetsManager.gray2)
            
        }
        .background(AssetsManager.background1)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
