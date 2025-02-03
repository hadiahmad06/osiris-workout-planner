//
//  WorkoutView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/19/24.
//

import SwiftUI

struct WorkoutView: View {
    @State var showEndView: Bool = false
    
    var body: some View {
        SlideViews(view1: WorkoutStartView(showEndView: $showEndView),
                   view2: WorkoutEndView(showEndView: $showEndView),
                   animationTime: 0.5,
                   direction: .horizontal,
                   showView2: $showEndView)
    }
}

struct ExerciseView: View {
    init() {
        
    }
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(AssetsManager.background2)
        }
    }
}

class TimerManager: ObservableObject {
    @Published var timeElapsed = 0
    @Published var formattedTime = "00:00"
    @Published var timerIsRunning = false
    
    var timer: Timer?
    
    // Function to start the timer
    func startTimer() {
        timerIsRunning = true
        timeElapsed = 0
        
        // Start the timer using a repeating timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.timerIsRunning {
                self.timeElapsed += 1
                self.updateFormattedTime()
            } else {
                self.stopTimer()
            }
        }
    }
    
    // Function to stop the timer
    func stopTimer() {
        timerIsRunning = false
        timer?.invalidate() // Stop the timer when not running
    }
    
    // Function to format the time as "00:00"
    func updateFormattedTime() {
        let hours = timeElapsed / 3600
        let minutes = (timeElapsed / 60) % 60
        let seconds = timeElapsed % 60
        if hours == 0 {
            formattedTime = String(format: "%02d:%02d", minutes, seconds)
        } else {
            formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

struct TimerView: View {
    @EnvironmentObject var localService: LocalService
    @ObservedObject var timerManager: TimerManager
    var body: some View {
        VStack {
            Text(timerManager.formattedTime)
                .font(.system(size: 23))
        }
        .onAppear {
            timerManager.timeElapsed = localService.workout.base.timeElapsed
            timerManager.updateFormattedTime()
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
