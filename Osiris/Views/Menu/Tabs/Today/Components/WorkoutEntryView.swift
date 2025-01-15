//
//  WorkoutEntryView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/5/25.
//
import SwiftUI

struct WorkoutEntryView: View {
    @EnvironmentObject var cloudService: CloudService
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            ZStack{
                let entries = cloudService.log.getEntries(forDate: selectedDate)
                ForEach(entries) { entry in
                    Text("")
                        .frame(width: 100, height: 100)
                        .background(AssetsManager.cardBackground)
                        .cornerRadius(15)
                        .padding(10)
                }
            }
        }
    }
}
