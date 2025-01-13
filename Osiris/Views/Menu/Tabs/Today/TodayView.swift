//
//  TodayView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
import SwiftUI
import Foundation

struct TodayView: View {
    @State var working: Bool = false
    
    var body: some View {
        if working {
            WorkoutView(working: $working)
        } else {
            WeekView(working: $working)
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
