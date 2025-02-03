//
//  WeekView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import SwiftUI
import Foundation

struct WeekView: View {
    @EnvironmentObject var cloudService: CloudService
    @EnvironmentObject var localService: LocalService
    
    @State private var weekOffset: Int = 0
    @State private var selectedDate: Date = Log.calendar().startOfDay(for: Date())
    @State private var dateOffset: Int = 0
    
    @State private var week: [(Date,StreakStatus)] = []
    @State var onUpdate: Bool = false
    
    func updateWeek() {
        self.week = cloudService.log.getWeekStatuses(weekOffset: weekOffset)
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(getDateString())
                    .foregroundStyle(AssetsManager.text1)
                    .font(.title)
                    .fontWeight(.bold)
            }
            let spacing: CGFloat = 7.0
            HStack(spacing: spacing) {
                Button(action: {weekOffset -= 1}) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.text1)
                }
                SlideWeek(week: week, selectedDate: $selectedDate, dateOffset: $dateOffset, spacing: spacing)
                Button(action: {weekOffset += 1}) {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.text1)
                }
            }
            .padding(.bottom, 15)
            .onAppear() {
                updateWeek()
            }
            .onChange(of: weekOffset) {
                updateWeek()
            }
            .onChange(of: onUpdate) {
                updateWeek()
                onUpdate = false
            }
            SlideWorkouts(selectedDate: selectedDate, dateOffset: dateOffset)
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Menu {
                        PlansView(selectedDate: $selectedDate,
                                  onUpdate: $onUpdate)
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
                    .padding()
                }
            }
        }
    }
    
    private func getDateString() -> String {
        let dateString: String
        if dateOffset == 0 {
            dateString = "Today"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            dateString = formatter.string(from: selectedDate)
        }
        return dateString
    }
}

struct SlideWorkouts: View {
    @EnvironmentObject var cloudService: CloudService
    @EnvironmentObject var localService: LocalService
    var selectedDate: Date
    var dateOffset: Int
    
    var body: some View {
        ZStack{
            if dateOffset <= 0 {
                let entries = cloudService.log.getEntries(forDate: selectedDate)
                Button(action: {localService.startWorkout()}) {
                    Text(getText(entries.isEmpty))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(AssetsManager.text1)
                        .background(AssetsManager.background3)
                        .cornerRadius(30)
                        .padding()
                }
                ForEach(entries) { entry in
                    Text("text")
                        .frame(width: 100, height: 100)
                        .foregroundColor(AssetsManager.text1)
                        .background(AssetsManager.cardBackground)
                        .cornerRadius(30)
                        .padding(10)
                }
            } else {
                Button(action: {Task {await cloudService.log.updateStatus(date: selectedDate)}}) {
                    Text("Mark as rest day?")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(AssetsManager.text1)
                        .background(AssetsManager.background3)
                        .cornerRadius(30)
                        .padding()
                }
            }
        }
    }
    
    private func getText(_ empty : Bool) -> String {
        let text: String
        if dateOffset == 0 {
            text = empty ? "Start Today's Workout!" : "Start Another Workout!"
        } else if dateOffset < 0 {
            text = empty ? "Log a Workout!" : "Log Another Workout!"
        } else {
            text = "how did u get here dawg"
        }
        return text
    }
}

struct SlideWeek: View {
    
    var week: [(Date, StreakStatus)]
    @Binding var selectedDate: Date
    @Binding var dateOffset: Int
    var spacing: CGFloat
    
    var body: some View {
        let scale: CGFloat = 9.0
        ForEach(week.indices, id: \.self) { index in
            let date = week[index].0
            let status = week[index].1
            let colors = getColorFromStatus(status: status)
            ZStack {
                if (index < 6 && week[index+1].1 == status) {
                    Rectangle()
                        .frame(width: (scale*4+spacing/2), height: (scale*4))
                        .foregroundColor(colors[1])
                        .offset(x: (scale*2+spacing/2))
                }
                Text("\(Calendar.current.component(.day, from: date))") // day of month
                    .foregroundColor(colors[0])
                    .font(.system(size: 16))
                    .frame(width: scale*2, height: scale*2)
                    .padding(scale)
                    .background(colors[1])
                    .cornerRadius(25)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .onTapGesture {
                        self.selectedDate = date
                        let today = Calendar.current.startOfDay(for: Date())
                        if Calendar.current.isDate(selectedDate, inSameDayAs: today) {
                            self.dateOffset = 0
                        } else {
                            let components = Calendar.current.dateComponents([.day], from: today, to: selectedDate)
                            self.dateOffset = components.day ?? 0
                        }
                    }
            }
            .frame(width: scale*4)
        }
    }
    
    private func getColorFromStatus(status: StreakStatus) -> [Color] {
        switch status {
        case .completed: return [AssetsManager.text1, AssetsManager.accent1]
        case .skipped: return [AssetsManager.text1, Color.indigo]
        case .missed: return [Color.black, Color.white]
        case .pending: return [AssetsManager.text1, AssetsManager.gray2]
        }
    }
}
