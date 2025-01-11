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
    @Binding var onUpdate: Bool
//    @Binding var week: [(Date,StreakStatus)]
    
    var body: some View {
        VStack(spacing: 11) {
            PlanRowView(imageName: "bed.double.fill",
                        text: "Set Rest Day",
                        action: {Task {await cloudService.log.updateStatus(date: selectedDate)}},
                        onUpdate: $onUpdate)
//            ForEach(cloudService.plan.plans) { plan in
//                PlanRowView(imageName: "bed.double.fill",
//                            text: plan.text,
//                            action: {Task {await cloudService.log.}})
//            }
            PlanRowView(imageName: "bed.double.fill",
                        text: "Set Rest Day",
                        action: {Task {await cloudService.log.updateStatus(date: selectedDate)}},
                        onUpdate: $onUpdate)
            PlanRowView(imageName: "bed.double.fill",
                        text: "Set Rest Day",
                        action: {Task {await cloudService.log.updateStatus(date: selectedDate)}},
                        onUpdate: $onUpdate)
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
        }
    }
}

extension Notification.Name {
    static let updateWeek = Notification.Name("updateWeek")
}
