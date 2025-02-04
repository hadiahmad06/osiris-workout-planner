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
    
    @State private var selectedIndex: Int = -1
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
                    let cardHeight = geometry.size.height
                    let spacing: CGFloat = 15

                    ZStack {
                        ForEach(entries.indices, id: \.self) { index in
                            VStack {
                                HStack {
                                    Text(entries[index].exercise.name)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(25)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        localService.removeExercise(selectedIndex)
                                        if selectedIndex != 0 { selectedIndex -= 1
                                        }
                                    } ) {
                                        Image(systemName: "multiply.square.fill")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color.red)
                                    }
                                    .padding(25)
                                }
                                Spacer()
                                VStack{
                                    VStack(spacing: 5) {
                                        let weightWidth: CGFloat = 80
                                        let repsWidth: CGFloat = 80
                                        let repsSmallWidth: CGFloat = 60
                                        HStack {
                                            Text("Set")
                                            Spacer()
                                            Text("Reps")
                                                .frame(width: repsWidth)
                                            Text("Weight")
                                                .frame(width: weightWidth)
                                        }
                                        .padding(.horizontal, 20)
                                        ForEach(entries[index].base.sets) { set in
                                            let reps = Binding<String>(
                                                get: { "\(set.reps ?? 0)" },
                                                set: { newValue in
                                                    if let intValue = Int(newValue) {
                                                        localService.editReps(intValue)
                                                    }
                                                }
                                            )
                                            let weight = Binding<String>(
                                                get: { "\(set.weight ?? 0)" },
                                                set: { newValue in
                                                    if let intValue = Int(newValue) {
                                                        localService.editWeight(intValue)
                                                    }
                                                }
                                            )

                                            HStack {
                                                Text("\(set.order)")
                                                Spacer()
                                                InputView(text: reps, placeholder: "10")
                                                    .frame(width: set.working ? repsWidth : repsSmallWidth)
                                                InputView(text: weight, placeholder: "10")
                                                    .frame(width: weightWidth)
                                            }
                                            .padding(.horizontal, 20)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                    .padding(25)
                                    
                                    Button(action: { localService.addSet() }) {
                                        Image(systemName: "plus.rectangle.fill")
                                            .foregroundColor(AssetsManager.accent1)
                                            .font(.system(size: 22))
                                            .shadow(radius: 3)
                                    }
                                    .padding(.bottom, 10)
                                    Spacer()
                                }
                            }
                            .frame(width: cardWidth, height: cardHeight)
                            .background(AssetsManager.background3)
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.2), radius: 8)
                            .scaleEffect(index == selectedIndex ? 1.0 : 0.85)
                            .offset(x: CGFloat(index - selectedIndex) * (cardWidth + spacing))
                            .scaleEffect(index == selectedIndex ? 1.0 : 0.85, anchor: .center)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                    .clipped()
                    .id(_updateView)
                }
                .onReceive(NotificationCenter.default.publisher(for: .workoutUpdated)) { _ in
                    updateView()
                }
                .onChange(of: selectedIndex) { _, newValue in
                    localService.navigate(toIdx: newValue)
                }
                
                Spacer()
                
                Button(action: {
                    localService.addExerciseEntry(id:"example", index: selectedIndex+1)
                    //auto navigates to newest entry
                    withAnimation(.spring()) {
                        selectedIndex = selectedIndex+1
                    }
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
