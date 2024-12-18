//
//  ContentView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/17/24.
//

import SwiftUI

var nextID: Int = 0
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

// AnyButton class inherits from Object and adds a pointer (closure)
class AnyButton: Object {
    var pointer: () -> Void
    
    // Initializer for AnyButton
    init(t: String, d: Int, p: @escaping () -> Void, s: Bool = false) {
        self.pointer = p
        super.init(t: t, d: d, s: s) // Call the superclass initializer
    }
    
    // Function to execute the pointer action
    func press() {
        pointer()
    }
}

// SpecialButton inherits from AnyButton and creates a new SwiftUI view when pressed
class SpecialButton: AnyButton {
    var newView: AnyView
    
    // Initializer with view
    init(t: String, d: Int, s: Bool = false, v: AnyView) {
        self.newView = v
        let newViewAction: () -> Void = {
            // Switch to the new view when pressed
            // You can customize the behavior here
            print("Switching to new view: \(t)")
        }
        super.init(t: t, d: d, p: newViewAction, s: s)
    }
    
    // Default initializer with a default workout plan view
    init(t: String, d: Int, s: Bool = false) {
        let defaultView = AnyView(WorkoutPlan(t: t))
        self.newView = defaultView
        let newViewAction: () -> Void = {
            // Switch to the new view when pressed
            // You can customize the behavior here
            print("Switching to new view: \(t)")
        }
        super.init(t: t, d: d, p: newViewAction, s: s)
    }
}
struct GlobalColorManager {
    static var accentColorMain: Color = Color("accent")
    static var accentColorSecondary: Color = Color(UIColor.systemGray4)
    static var accentColorTertiary: Color = Color(UIColor.systemGray)
    static var textColor: Color = Color(UIColor.label)
    static var backgroundColor: Color = Color(UIColor.systemBackground)
    static var backgroundAccent: Color = Color(UIColor.secondarySystemBackground)
    static var buttonColor: Color = accentColorMain
    static var buttonTextColor: Color = Color(UIColor.label)
    static var listBackgroundColor: Color = Color.white.opacity(0.5)
    static var cardBackgroundColor: Color = accentColorMain
    static var shadowColor: Color = Color.black.opacity(0)
}

var daysOfWeek: [Object] = [
    Object(t: "S", d: 2, c:GlobalColorManager.accentColorMain), // 0 -> date is in the future or today
    Object(t: "M", d: 1, c:GlobalColorManager.accentColorSecondary), // 1 -> rest day
    Object(t: "T", d: 1, c:GlobalColorManager.accentColorTertiary), // 2 -> completed day
    Object(t: "W", d: 0, c:GlobalColorManager.accentColorTertiary),
    Object(t: "T", d: 0, c:GlobalColorManager.accentColorTertiary),
    Object(t: "F", d: 0, c:GlobalColorManager.accentColorTertiary),
    Object(t: "S", d: 0, c:GlobalColorManager.accentColorTertiary)
]

struct WorkoutPlan: View {
    var text: String
    
    init(t: String) {
        text = t
    }
    var body: some View {
        VStack {
            Text(text)
                .font(.largeTitle)
                .foregroundColor(GlobalColorManager.textColor)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

var workoutPlans: [SpecialButton] = [
    SpecialButton(t: "1", d: 1, s: false),
    SpecialButton(t: "2", d: 2, s: false),
    SpecialButton(t: "3", d: 3, s: false),
    SpecialButton(t: "4", d: 4, s: false),
    SpecialButton(t: "5", d: 5, s: false),
    SpecialButton(t: "6", d: 6, s: false)
]
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
            .background(GlobalColorManager.backgroundColor)
            .shadow(color: GlobalColorManager.shadowColor, radius: 5)
        }
        .background(GlobalColorManager.backgroundAccent)
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
                    .foregroundColor(selectedTab == tab ? GlobalColorManager.accentColorMain : GlobalColorManager.accentColorSecondary)
//                Text(tabTitle(for: tab))
//                    .foregroundColor(GlobalColorManager.textColor)
//                    .font(.system(size: isMainButton ? 16 : 12))
//                    .foregroundColor(selectedTab == tab ? GlobalColorManager.accentColorMain : GlobalColorManager.accentColorSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func iconName(for tab: ContentView.Tab) -> String {
        switch tab {
        case .stats: return "chart.bar.fill"
        case .social: return "person.2.fill"
        case .today: return "calendar.circle.fill"
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
                .foregroundColor(GlobalColorManager.textColor)
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
                .foregroundColor(GlobalColorManager.textColor)
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
                    .background(GlobalColorManager.buttonColor)
                    .foregroundColor(GlobalColorManager.buttonTextColor)
                    .cornerRadius(10)
            }
            .padding()

            Text("Friends List")
                .foregroundColor(GlobalColorManager.textColor)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)

            List(friends, id: \.self) { friend in
                Text(friend)
                    .foregroundColor(GlobalColorManager.textColor)
                    .padding()
                    .background(GlobalColorManager.listBackgroundColor)
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
            Text("This Week's Dates")
                .foregroundColor(GlobalColorManager.textColor)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            HStack {
                //var color : Color = GlobalColorManager.accentColorSecondary
                // Use ForEach with enumerated to get both index and value
                //ForEach(Array(daysOfWeek.enumerated()), id: \.element.text) { _, day in
                ForEach(daysOfWeek) { day in
//                    let color: Color
//                    switch day.data {
//                    case 1:
//                        color = GlobalColorManager.accentColorSecondary.opacity(0.5)
//                    case 2:
//                        color = GlobalColorManager.accentColorTertiary
//                    default:
//                        color = GlobalColorManager.accentColorMain
//                    }
                    Text(day.text)
                        .foregroundColor(GlobalColorManager.textColor)
                        .font(.headline)
                        .frame(width: 15, height: 15)
                        .padding(12)
                        .background(day.color)
                        .cornerRadius(25)
                }
            }
            .padding()

            // Display 4 Customizable Workout Plan Boxes
            Text("Customize Your Workout Plans")
                .foregroundColor(GlobalColorManager.buttonTextColor)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            let index = row * 3 + column
                            if index < workoutPlans.count {
                                VStack {
                                    Text(workoutPlans[index].text)
                                        .foregroundColor(GlobalColorManager.buttonTextColor)
                                        .font(.headline)
                                        .frame(width: 100, height: 100)
                                        .background(GlobalColorManager.cardBackgroundColor)
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

            Button(action: {
                // Action to create a custom workout
            }) {
                Text("Create Custom Workout")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(GlobalColorManager.buttonColor)
                    .foregroundColor(GlobalColorManager.buttonTextColor)
                    .cornerRadius(10)
                    .padding(.top)
            }
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
                .foregroundColor(GlobalColorManager.textColor)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Username: User123")
                .foregroundColor(GlobalColorManager.textColor)
                .font(.title)
                .padding(.top)

            Text("Settings")
                .foregroundColor(GlobalColorManager.textColor)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)

            List {
                Text("Theme Settings")
                Text("Account Settings")
                Text("Privacy Settings")
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
