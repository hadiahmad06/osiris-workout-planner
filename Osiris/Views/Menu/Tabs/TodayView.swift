//
//  TodayView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
import SwiftUI
import Foundation

struct TodayView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var weekOffset = 0
    @State private var selectedDate = Log.calendar().startOfDay(for: Date())
    var body: some View {
        VStack {
            // Display Dates for This Week (Sunday-Saturday)
            HStack{
                Text("Today:")
                    .foregroundColor(AssetsManager.textColor)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    //.padding(.top)
                Text("Push")
                    .foregroundStyle(AssetsManager.textColor)
                    .font(.title)
                    .fontWeight(.bold)
            }
            HStack {
                Button(action: {weekOffset -= 1}) {
                    Image(systemName: "chevron.backward")
                }
                let week = viewModel.getWeekStatuses(weekOffset: weekOffset)
                ForEach(week, id: \.0) { (date, status) in
                    // i had to add empty id value because of foreach
                        Button(action: {selectedDate = date}) {
                            Text("\(Calendar.current.component(.day, from: date))") // day of month
                                .foregroundColor(AssetsManager.textColor)
                                .font(.system(size: 11))
                                .frame(width: 15, height: 15)
                                .padding(11)
                                .background(getColorFromStatus(status: status))
                                .cornerRadius(25)
                        }
                    }
                //}
                Button(action: {weekOffset += 1}) {
                    Image(systemName: "chevron.forward")
                }
                
            }
            .padding(.bottom, 15)
            
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            let index = row * 3 + column
                            if index < workoutPlans.count {
                                Button(action: {}) {
                                    Text(workoutPlans[index].text)
                                        .foregroundColor(AssetsManager.buttonTextColor)
                                        .font(.headline)
                                        .frame(width: 100, height: 100)
                                        .background(AssetsManager.cardBackgroundColor)
                                        .cornerRadius(15)
                                        .padding(5)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            Spacer()
            VStack {
                Button(action: {
                    Task {
                        viewModel.currentLog!.updateStreak(date: selectedDate, status: .skipped)
                            //await viewModel.addStreakStatus(date: selectedDate, streakStatus: .skipped)
                    }
                }) {
                    Text("Set Rest Day")
                        .font(.title)
                        .foregroundColor(AssetsManager.buttonTextColor)
                        .frame(width:200, height: 80)
                        .background(AssetsManager.cardBackgroundColor)
                        .cornerRadius(50)
                }
                Button(action: {
                    Task {
                        await viewModel.addStreakStatus(date: selectedDate, status: .pending)
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(AssetsManager.buttonTextColor)
                        .frame(width:200, height: 80)
                        .background(AssetsManager.cardBackgroundColor)
                        .cornerRadius(50)
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Today", displayMode: .inline)
    }
    
    private func getColorFromStatus(status: StreakStatus) -> Color {
        switch status {
        case .completed: return AssetsManager.accentColorMain
        case .skipped: return Color.orange
        case .missed: return Color.red
        case .pending: return AssetsManager.accentColorTertiary
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(AuthViewModel.EXAMPLE_VIEW_MODEL)
    }
}
