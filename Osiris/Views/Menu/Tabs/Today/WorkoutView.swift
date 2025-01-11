//
//  WorkoutView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/19/24.
//

import SwiftUI

struct WorkoutView: View {
    @Binding var working: Bool
    
    @StateObject private var timerManager = TimerManager()
    
    @State private var timerIsRunning = true
    @State private var buttonText = "Stop"
    
    
    var body: some View {
        VStack {
            ZStack {
                // Rounded rectangle with the top hidden and bottom curves visible
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: 300)
                    .foregroundColor(AssetsManager.backgroundAccent)
                    .offset(y: -75)  // Move the rectangle up to hide the top part
                    .clipped() // Ensure that only the bottom curve is visible
                
                // Text inside the rectangle
                HStack {
                    VStack {
                        Text("Workout")
                            .offset(y:120)
                            .offset(x:-50)
                            .font(.title)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(AssetsManager.accentColorMain)
                                .font(.system(size: 25))
                                .padding()
                            TimerView(timerManager: timerManager)
                                .offset(x:-35)
                        }
                        .offset(x:-40)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .offset(y:10)
                    VStack{
                        HStack {
                            Button(action: {
                                if timerIsRunning {
                                    timerIsRunning = false
                                    buttonText = "Start"
                                    timerManager.stopTimer()
                                } else {
                                    timerIsRunning = true
                                    buttonText = "Stop"
                                    timerManager.startTimer()
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 80, height: 30)
                                        .foregroundStyle(AssetsManager.accentColorMain)
                                    Text(buttonText)
                                        .foregroundColor(AssetsManager.buttonTextColor)
                                        .font(.system(size: 18))
                                        .padding()
                                }
                                .offset(y:25)
                            }
                            .padding(20)
                        }
                    }
                }
            }
            .frame(height: 75) // Ensure the geometry takes up full height
            .background(AssetsManager.backgroundColor)
            
            // Additional content below the rectangle
            Spacer()
            Text("WorkoutView")
            
        }
        .background(AssetsManager.backgroundColor)
    }
}

struct ExerciseView: View {
    init() {
        
    }
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(AssetsManager.backgroundAccent)
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
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        formattedTime = String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView: View {
    @ObservedObject var timerManager: TimerManager
        
    var body: some View {
        VStack {
            Text(timerManager.formattedTime)
                .font(.system(size: 23))
                .padding()
        }
        .onAppear {
            timerManager.formattedTime = "00:00"
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(working: .constant(true))
    }
}
