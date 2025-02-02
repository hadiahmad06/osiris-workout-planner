//
//  TodayView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
import SwiftUI
import Foundation

struct TodayView: View {
    @EnvironmentObject var localService: LocalService
    @State var showWorkoutView: Bool = false
    
    private func updateInView() {
        showWorkoutView = localService.working
    }
    
    var body: some View {
        Group{
            SlideViews(view1: WeekView(),
                       view2: WorkoutView(),
                       animationTime: 0.5,
                       direction: .vertical,
                       showView2: $showWorkoutView)
        }
        .onAppear {
            updateInView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .showWorkoutViewChanged)) {_ in
            updateInView()
        }
    }
        
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
