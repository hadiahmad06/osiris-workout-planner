//
//  ContentView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/17/24.
//

import SwiftUI

// Global color configuration
class Object: Identifiable {
    var text: String
    var data: Int
    var color: Color
    var symbol: Bool
    
    var id : Int
    private static var nextID: Int = 0
    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
    
    // Initializer for Object
    init(t: String, d: Int, s: Bool = false, c: Color = .primary) {
        text = t
        data = d
        symbol = s
        color = c
        
        self.id = Object.idQueue.sync {
            let currentID = Object.nextID
            Object.nextID += 1
            return currentID
        }
    }
}

var daysOfWeek: [Object] = [
    Object(t: "S", d: 2, c:AssetsManager.accentColorMain), // 0 -> date is in the future or today
    Object(t: "M", d: 1, c:AssetsManager.accentColorSecondary), // 1 -> rest day
    Object(t: "T", d: 1, c:AssetsManager.accentColorTertiary), // 2 -> completed day
    Object(t: "W", d: 0, c:AssetsManager.accentColorTertiary),
    Object(t: "T", d: 0, c:AssetsManager.accentColorTertiary),
    Object(t: "F", d: 0, c:AssetsManager.accentColorTertiary),
    Object(t: "S", d: 0, c:AssetsManager.accentColorTertiary)
]

var workoutPlans: [WorkoutPlan] = [
    WorkoutPlan(text: "Plan 1"),
    WorkoutPlan(text: "Plan 2"),
    WorkoutPlan(text: "Plan 3"),
    WorkoutPlan(text: "Plan 4"),
    WorkoutPlan(text: "Plan 5"),
    WorkoutPlan(text: "Plan 6"),
    WorkoutPlan(text: "Plan 7"),
    WorkoutPlan(text: "Plan 8"),
    WorkoutPlan(text: "Plan 9")]
var friends = ["John", "Emma", "Liam"]


struct ContentView: View {
    @State private var selectedTab: Tab = .today
    
    enum Tab {
        case stats, social, today, plan, settings
    }
    
    var body: some View {
        VStack {
            // Content Area based on selected Tab
            switch selectedTab {
            case .stats:
                StatsView()
            case .social:
                SocialView()
            case .today:
                TodayView()
            case .plan:
                HomeView()
            case .settings:
                SettingsView()
            }

            Spacer()

            // Bottom Navigation Bar
            HStack {
                Spacer()

                TabButton(tab: .stats, selectedTab: $selectedTab)
                Spacer()

                TabButton(tab: .social, selectedTab: $selectedTab)
                Spacer()

                TabButton(tab: .today, selectedTab: $selectedTab, isMainButton: true)
                Spacer()

                TabButton(tab: .plan, selectedTab: $selectedTab)
                Spacer()

                TabButton(tab: .settings, selectedTab: $selectedTab)
                Spacer()
            }
            .padding()
            .background(AssetsManager.backgroundColor)
            .shadow(color: AssetsManager.shadowColor, radius: 5)
        }
        .background(AssetsManager.backgroundAccent)
    }
}

struct TabButton: View {
    var tab: ContentView.Tab
    @Binding var selectedTab: ContentView.Tab
    var isMainButton: Bool = false
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: iconName(for: tab))
                    .font(.system(size: isMainButton ? 32 : 24))
                    .foregroundColor(selectedTab == tab ? AssetsManager.accentColorMain : AssetsManager.accentColorSecondary)
//                Text(tabTitle(for: tab))
//                    .foregroundColor(AssetsManager.textColor)
//                    .font(.system(size: isMainButton ? 16 : 12))
//                    .foregroundColor(selectedTab == tab ? AssetsManager.accentColorMain : AssetsManager.accentColorSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func iconName(for tab: ContentView.Tab) -> String {
        switch tab {
        case .stats: return "chart.bar.fill"
        case .social: return "person.2.fill"
        case .today: return "calendar"
        case .plan: return "note.text"
        case .settings: return "gearshape.fill"
        }
    }
    
//    func tabTitle(for tab: ContentView.Tab) -> String {
//        switch tab {
//        case .stats: return "Stats"
//        case .social: return "Social"
//        case .today: return "Today"
//        case .plan: return "Plan"
//        case .settings: return "Settings"
//        }
//    }
}

struct StatsView: View {
    var body: some View {
        VStack {
            Text("Stats")
                .foregroundColor(AssetsManager.textColor)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .navigationBarTitle("Stats", displayMode: .inline)
    }
}

struct SocialView: View {
    @State private var friends: [String] = ["John", "Emily", "Mark"] // Sample friends
    
    var body: some View {
        VStack {
            Text("Add Friends")
                .foregroundColor(AssetsManager.textColor)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Button(action: {
                // Action to add friend
            }) {
                Text("Add Friends")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AssetsManager.buttonColor)
                    .foregroundColor(AssetsManager.buttonTextColor)
                    .cornerRadius(10)
            }
            .padding()

            Text("Friends List")
                .foregroundColor(AssetsManager.textColor)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)

            List(friends, id: \.self) { friend in
                Text(friend)
                    .foregroundColor(AssetsManager.textColor)
                    .padding()
                    .background(AssetsManager.listBackgroundColor)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Social", displayMode: .inline)
    }
}

struct TodayView: View {
    var body: some View {
        VStack {
            // Display Dates for This Week (Sunday-Saturday)
//            Text("This Week's Dates")
//                .foregroundColor(AssetsManager.textColor)
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top)

            HStack {
                //var color : Color = AssetsManager.accentColorSecondary
                // Use ForEach with enumerated to get both index and value
                //ForEach(Array(daysOfWeek.enumerated()), id: \.element.text) { _, day in
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
            .padding()

            // Display 4 Customizable Workout Plan Boxes
//            Text("Customize Your Workout Plans")
//                .foregroundColor(AssetsManager.buttonTextColor)
//                .font(.title2)
//                .fontWeight(.semibold)
//                .padding(.top)
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

//            Button(action: {
//                // Action to create a custom workout
//            }) {
//                Text("Create Custom Workout")
//                    .font(.title2)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(AssetsManager.buttonColor)
//                    .foregroundColor(AssetsManager.buttonTextColor)
//                    .cornerRadius(10)
//                    .padding(.top)
//            }
        }
        .padding()
        .navigationBarTitle("Today", displayMode: .inline)
    }

//    func getDayOfWeek(_ index: Int) -> String {
//        let calendar = Calendar.current
//        let today = Date()
//        let startOfWeek = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: today) + 1, to: today)!
//        let dayOfWeek = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE"
//        return formatter.string(from: dayOfWeek)
//    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Your Workout Today")
                .foregroundColor(AssetsManager.textColor)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
