//
//  WorkoutStart.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/31/25.
//

import SwiftUI

struct WorkoutStartView: View {
    @EnvironmentObject var localService: LocalService
    @StateObject private var timerManager = TimerManager()
    
    @State private var timerIsRunning = true
    @State private var buttonText = "Stop"
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: 300)
                    .foregroundColor(AssetsManager.background2)
                    .offset(y: -75)
                    .clipped()
                HStack {
                    VStack {
                        Text("Workout")
                            .offset(y:120)
                            .offset(x:-50)
                            .font(.title)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(AssetsManager.accent1)
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
                                        .foregroundStyle(AssetsManager.accent1)
                                    Text(buttonText)
                                        .foregroundColor(AssetsManager.white)
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
            //.frame(height: 75) // Ensure the geometry takes up full height
            .background(AssetsManager.background1)
            Button(action: {localService.cancelWorkout()}) {
                Text("Cancel workout")
                    .padding(20)
                    .cornerRadius(15)
                    .background(AssetsManager.accent1)
                    .foregroundColor(AssetsManager.text1)
            }
        }
        .background(AssetsManager.background1)
    }
}
