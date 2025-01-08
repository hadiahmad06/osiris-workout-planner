//
//  PlansView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/3/25.
//

import SwiftUI

struct PlansView: View {
    @EnvironmentObject var cloudService: CloudService
    @Binding var selectedDate: Date
    var body: some View {
        VStack(spacing: 11) {
            Button(action: {Task {await cloudService.log.updateStatus(date: selectedDate)}}) {
                PlanRowView(imageName: "bed.double.fill", text: "Set Rest Day")
            }
            Button(action: {Task {await cloudService.log.updateStatus(date: selectedDate)}}) {
                PlanRowView(imageName: "bed.double.fill", text: "Set Rest Day")
            }
            Button(action: {Task {await cloudService.log.updateStatus(date: selectedDate)}}) {
                PlanRowView(imageName: "bed.double.fill", text: "Set Rest Day")
            }
        }
        .padding()
    }
}

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
