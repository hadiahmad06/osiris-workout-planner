//
//  TodayView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
import SwiftUI
import Foundation

struct TodayView: View {
    @EnvironmentObject var cloudService: CloudService
    //@State private var showPopUp = false
    @State private var weekOffset: Int = 0
    @State private var selectedDate: Date = Log.calendar().startOfDay(for: Date())
    
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
                let week = cloudService.log.getWeekStatuses(weekOffset: weekOffset)
                Button(action: {weekOffset -= 1}) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.accentColorMain)
                }
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
                        .font(.system(size: 15))
                        .foregroundColor(AssetsManager.accentColorMain)
                }
            }
            .padding(.bottom, 15)
            
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
                        PlansView(selectedDate: $selectedDate)
                            .offset(y: -40)
                            .frame(alignment: .bottom)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(AssetsManager.buttonTextColor)
                                .frame(width:60, height: 60)
                                .background(AssetsManager.cardBackgroundColor)
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
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
