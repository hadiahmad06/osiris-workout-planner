//
//  StartupView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/19/24.
//

import SwiftUI

struct StartupView: View {
    @State private var progress: Double = 0
    private let maxWidth: CGFloat = 150
    private let height: CGFloat = 8
    private let cornerRadius: CGFloat = 10
    private let duration: Double = 3 // Duration in seconds
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
            //Spacer()
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 120))
                .foregroundColor(GlobalColorManager.accentColorMain)
            ZStack(alignment: .leading) {
                // Background of the loading bar
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(GlobalColorManager.accentColorSecondary)
                    .frame(width: maxWidth, height: height)
                
                // Animated fill of the loading bar
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(GlobalColorManager.accentColorMain)
                    .frame(width: maxWidth * progress, height: height)
                    .animation(.easeInOut(duration: duration), value: progress)
            }
            .onAppear {
                startLoading()
            }
            //Spacer()
            
        }
        .background(GlobalColorManager.backgroundColor)
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
