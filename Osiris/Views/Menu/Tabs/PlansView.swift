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
