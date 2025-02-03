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
    @State private var _updateView: Bool = false
    
    @Binding var showEndView: Bool
    
    @State private var timerIsRunning = true
    @State private var confirmCancel = false
    
    @State private var entries: [ExerciseEntryUI] = []
    
    private func updateView() {
        _updateView.toggle()
    }
    
    var body: some View {
        if localService.working {
            VStack {
                WorkoutHeaderView(showEndView: $showEndView)
                
                Spacer()
                
                let entries = localService.workout.exerciseEntriesUI

                GeometryReader { geometry in
                    let cardWidth = geometry.size.width * 0.8
                    let sideCardWidth = geometry.size.width * 0.4

                    ZStack {
                        ForEach(entries.indices, id: \.self) { index in
                            VStack {
                                Text(entries[index].exercise.name)
                                ForEach(entries[index].base.sets) { set in
//                                    let set = Set()
//                                    Text(set.weight ?? "0")
//                                    Text(set.reps ?? "0")
                                }
                                Button(action: {localService.addSet()}) {
                                    Image(systemName: "plus.rectangle.fill")
                                        .foregroundColor(AssetsManager.accent1)
                                        .font(.system(size: 18))
                                }
                                    
                            }
                            .frame(width: index == selectedIndex ? cardWidth : sideCardWidth * 0.7,
                                   height: index == selectedIndex ? 350 : 250)
                            .background(AssetsManager.background3)
                            .cornerRadius(25)
                            .scaleEffect(index == selectedIndex ? 1.0 : 0.85)
                            //.opacity(index == selectedIndex ? 1.0 : 0.7)
                            .offset(x: CGFloat(index - selectedIndex) * (cardWidth * 0.75))
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: 300)
                    .clipped() // Prevents overflowing views
                }
                .onReceive(NotificationCenter.default.publisher(for: .workoutUpdated)) { _ in
                    updateView()
                }
                .onChange(of: selectedIndex) { _, newValue in
                    localService.navigate(toIdx: newValue)
                }
                
                Spacer()
                
                Button(action: { localService.addExerciseEntry("example") }) {
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
            //        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: ContentView.allowedHeight)
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
                        .font(.system(size: 18))
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(AssetsManager.background3)
        .cornerRadius(50)
        .frame(height: 175, alignment: .top)
        .ignoresSafeArea(edges: .top)
    }
}
