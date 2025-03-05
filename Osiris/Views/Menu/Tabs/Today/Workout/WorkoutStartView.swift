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
    
    @State private var selectedIndex: Int = 0
    @State private var updateIndex: Bool = false
    @State private var updateView: Bool = false
    
    @Binding var showEndView: Bool
    
    // header
    @State private var timerIsRunning = true
    @State private var confirmCancel = false
    
    @State private var entries: [ExerciseEntryUI] = []
    
    
    var body: some View {
        if localService.working {
            VStack {
                WorkoutHeaderView(showEndView: $showEndView)
                Spacer()
                
                ExerciseSliderView(entries: localService.workout.exerciseEntriesUI,
                                   selectedIndex: $selectedIndex,
                                   updateIndex: $updateIndex,
                                   updateView: $updateView)
                .id(updateView)
                Spacer()
                
                Button(action: {
                    localService.addExerciseEntry(id: "example", index: selectedIndex == 0 ? 0 : selectedIndex + 1)
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
                        selectedIndex = localService.workout.exerciseEntriesUI.count - 1
                    }
                    updateIndex.toggle()
                    updateView.toggle()
                }) {
                    Text("Add Exercise")
                        .font(.system(size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AssetsManager.accent1)
                        .foregroundColor(AssetsManager.text1)
                        .cornerRadius(15)
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AssetsManager.background2)
        } else {
            Text("Loading...")
        }
    }
}

struct WorkoutStartView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStartView(showEndView: .constant(false))
            .environmentObject(LocalService.EXAMPLE_LOCAL_SERVICE)
    }
}


struct WorkoutHeaderView: View {
    @EnvironmentObject var localService: LocalService
    @StateObject private var timerManager = TimerManager()
    
    @Binding var showEndView: Bool
    @State private var confirmCancel = false
    
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text(localService.workout.base.name ?? "Custom")
                        .font(.title)
                    // should be editable in future
                    TimerView(timerManager: timerManager)
                }
                .padding()
                
                Spacer()
                Button(action: {
                    showEndView = true
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 100, height: 40)
                        .foregroundColor(AssetsManager.accent1)
                        .overlay(
                            Text("Finish")
                                .foregroundColor(AssetsManager.white)
                                .font(.system(size: 18))
                        )
                }
                .padding()
                Button(action: {
                    if confirmCancel {
                        localService.cancelWorkout()
                    } else {
                        confirmCancel = true
                    }
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color.red)
                        .font(.system(size: 30))
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(AssetsManager.background3)
        .cornerRadius(50)
        .frame(height: 175, alignment: .top)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .top)
    }
}


struct SetsView: View {
    @EnvironmentObject var localService: LocalService
    var entry: ExerciseEntryUI
    
    var body: some View {
        VStack(spacing: 5) {
            let setHeight: CGFloat = 22
            let setWidth: CGFloat = 50
            let weightWidth: CGFloat = 80
            let repsWidth: CGFloat = 80
            let repsSmallWidth: CGFloat = 60
            HStack {
                Text("Set")
                    .frame(width: setWidth, alignment: .center)
                Spacer()
                Text("Reps")
                    .frame(width: repsWidth, alignment: .center)
                Text("Weight")
                    .frame(width: weightWidth, alignment: .center)
            }
            .padding(.horizontal, 20)
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(entry.base.sets) { set in
                        let reps = Binding<String>(
                            get: { set.reps == nil ? "" : "\(set.reps ?? 0)" },
                            set: { newValue in
                                if let intValue = Int(newValue) {
                                    localService.editReps(intValue)
                                }
                            }
                        )
                        let weight = Binding<String>(
                            get: { set.weight == nil ? "" : "\(set.weight ?? 0)" },
                            set: { newValue in
                                if let intValue = Int(newValue) {
                                    localService.editWeight(intValue)
                                }
                            }
                        )
                        
                        HStack {
                            Text("\(set.order)")
                                .frame(width: setWidth)
                            Spacer()
                            HStack {
                                InputView(text: reps,
                                          placeholder: "10",
                                          align: true)
                                .frame(width: set.working ? repsWidth : repsSmallWidth,
                                       height: setHeight)
                                Divider()
                                    .frame(maxHeight: 13)
                                    .foregroundColor(AssetsManager.text1)
                                InputView(text: weight,
                                          placeholder: "10",
                                          align: true)
                                .frame(width: weightWidth,
                                       height: setHeight)
                            }
                            .background(AssetsManager.background2)
                            .cornerRadius(10)
                        }
                        //.frame(maxHeight: 15)
                        .padding(.horizontal, 20)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .padding(25)
    }
}
