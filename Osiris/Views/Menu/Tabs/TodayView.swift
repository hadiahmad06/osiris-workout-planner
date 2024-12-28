//
//  TodayView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
import SwiftUI
import Foundation

struct TodayView: View {
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
                ForEach(daysOfWeek) { day in
                    Text(day.text)
                        .foregroundColor(AssetsManager.textColor)
                        .font(.headline)
                        .frame(width: 15, height: 15)
                        .padding(12)
                        .background(day.color)
                        .cornerRadius(25)
                }
            }
            //.padding()
            
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
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Today", displayMode: .inline)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
