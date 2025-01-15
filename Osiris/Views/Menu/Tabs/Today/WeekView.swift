//
//  WeekView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var cloudService: CloudService
    @Binding var working: Bool
    
    //@State private var showPopUp = false
    @State private var weekOffset: Int = 0
    @State private var selectedDate: Date = Log.calendar().startOfDay(for: Date())
    
    @State private var week: [(Date,StreakStatus)] = []
    @State private var onUpdate: Bool = false
    
//    init(_ working: Binding<Bool>) {
//        self.working = working.wrappedValue
//    }
    
    func updateWeek() {
        self.week = cloudService.log.getWeekStatuses(weekOffset: weekOffset)
    }
    var body: some View {
        VStack {
            // Display Dates for This Week (Sunday-Saturday)
            HStack{
                Text("Today:")
                    .foregroundColor(AssetsManager.text1)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    //.padding(.top)
                Text("Push")
                    .foregroundStyle(AssetsManager.text1)
                    .font(.title)
                    .fontWeight(.bold)
            }
            HStack {
                //let week = cloudService.log.getWeekStatuses(weekOffset: weekOffset)
                Button(action: {weekOffset -= 1}) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.accent1)
                }
                if !onUpdate {
                    ForEach(week, id: \.0) { (date, status) in
                        // i had to add empty id value because of foreach
                        Button(action: {selectedDate = date}) {
                            Text("\(Calendar.current.component(.day, from: date))") // day of month
                                .foregroundColor(AssetsManager.text1)
                                .font(.system(size: 11))
                                .frame(width: 15, height: 15)
                                .padding(11)
                                .background(getColorFromStatus(status: status))
                                .cornerRadius(25)
                        }
                    }
                    //}
                }
                Button(action: {weekOffset += 1}) {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.accent1)
                }
            }
            .padding(.bottom, 15)
            .onAppear() {
                updateWeek()
            }
            .onChange(of: weekOffset) {
                updateWeek()
            }
            .onChange(of: onUpdate) { _, newValue in
                if newValue {
                    self.week = .init()
                    updateWeek()
                    onUpdate = false
                }
            }
            
            WorkoutEntryView(selectedDate: $selectedDate)
//            VStack {
//                ForEach(0..<3) { row in
//                    HStack {
//                        ForEach(0..<3) { column in
//                            let index = row * 3 + column
//                            if index < workoutPlans.count {
//                                Button(action: {}) {
//                                    Text(workoutPlans[index].text)
//                                        .foregroundColor(AssetsManager.buttonTextColor)
//                                        .font(.headline)
//                                        .frame(width: 100, height: 100)
//                                        .background(AssetsManager.cardBackgroundColor)
//                                        .cornerRadius(15)
//                                        .padding(5)
//                                }
//                                .frame(maxWidth: .infinity)
//                            }
//                        }
//                    }
//                }
//            }
            Spacer()
            HStack {
                Spacer()
                
                ZStack {
                    Menu {
                        PlansView(selectedDate: $selectedDate, onUpdate: $onUpdate)
                            .offset(y: -40)
                            .frame(alignment: .bottom)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(AssetsManager.white)
                                .frame(width:60, height: 60)
                                .background(AssetsManager.cardBackground)
                                    .cornerRadius(50)
                    }
//                    Button(action: {
//                        Task {
//                            showPopUp.toggle()
//                        }
//                    }) {
//                        Image(systemName: "plus")
//                            .font(.title)
//                            .foregroundColor(AssetsManager.buttonTextColor)
//                            .frame(width:60, height: 60)
//                            .background(AssetsManager.cardBackgroundColor)
//                            .cornerRadius(50)
//                    }
//                    if showPopUp {
//                        PlansView()
//                            .offset(y: -40)
//                            .frame(alignment: .bottom)
//                    }
                        
                }
            }
        }
        .padding()
        .navigationBarTitle("Today", displayMode: .inline)
    }
    
    private func getColorFromStatus(status: StreakStatus) -> Color {
        switch status {
        case .completed: return AssetsManager.accent1
        case .skipped: return Color.orange
        case .missed: return Color.red
        case .pending: return AssetsManager.gray2
        }
    }
}
