//
//  PlansView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/3/25.
//

import SwiftUI

struct PlansView: View {
    @EnvironmentObject var cloudService: CloudService
    @EnvironmentObject var localService: LocalService
    @Binding var selectedDate: Date
    @Binding var onUpdate: Bool
    
    var body: some View {
        VStack(spacing: 11) {
            
            PlanRowView(imageName: "figure.mixed.cardio",
                        text: "Custom Workout",
                        action: {localService.startWorkout()},
                        onUpdate: $onUpdate)
            PlanRowView(imageName: "bed.double.fill",
                        text: "Set Rest Day",
                        action: {Task {await cloudService.log.updateStatus(date: selectedDate)}},
                        onUpdate: $onUpdate)
            ForEach(cloudService.plan.plans) { plan in
                PlanRowView(imageName: plan.symbol ?? "figure",
                            text: plan.name,
                            action: {localService.startWorkout(plan)},
                            onUpdate: $onUpdate)
            }
        }
        .padding()
    }
}

struct PlanRowView: View {
    let imageName: String
    let text: String
    let action: () -> Void
    
    @Binding var onUpdate: Bool
    
//    init(imageName: String, text: String, action: @escaping () -> Void) {
//        self.imageName = imageName
//        self.text = text
//        self.action = {
//            action()
//            onUpdate = true
//        }
//    }
    
    var body: some View {
        Button(action: {action(); onUpdate = true}) {
            HStack {
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(AssetsManager.accent1)
                Spacer()
                Text(text)
                    .font(.headline)
                    .foregroundColor(AssetsManager.text1)
                
            }
            .frame(maxWidth: 200)
            .padding(15)
            .background(AssetsManager.gray1)
            .cornerRadius(8)
        }
    }
}

extension Notification.Name {
    static let updateWeek = Notification.Name("updateWeek")
}
