//
//  ContentView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/17/24.
//

import SwiftUI

// Global color configuration
//class Object: Identifiable {
//    var text: String
//    var data: Int
//    var color: Color
//    var symbol: Bool
//    
//    var id : Int
//    private static var nextID: Int = 0
//    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
//    
//    // Initializer for Object
//    init(t: String, d: Int, s: Bool = false, c: Color = .primary) {
//        text = t
//        data = d
//        symbol = s
//        color = c
//        
//        self.id = Object.idQueue.sync {
//            let currentID = Object.nextID
//            Object.nextID += 1
//            return currentID
//        }
//    }
//}

//var daysOfWeek: [Object] = [
//    Object(t: "S", d: 2, c:AssetsManager.accentColorMain), // 0 -> date is in the future or today
//    Object(t: "M", d: 1, c:AssetsManager.accentColorSecondary), // 1 -> rest day
//    Object(t: "T", d: 1, c:AssetsManager.accentColorTertiary), // 2 -> completed day
//    Object(t: "W", d: 0, c:AssetsManager.accentColorTertiary),
//    Object(t: "T", d: 0, c:AssetsManager.accentColorTertiary),
//    Object(t: "F", d: 0, c:AssetsManager.accentColorTertiary),
//    Object(t: "S", d: 0, c:AssetsManager.accentColorTertiary)
//]

//var workoutPlans: [Plan] = [
//    Plan(id: "awd", name: "Plan 1"),
//    Plan(id: "awd", name: "Plan 2"),
//    Plan(id: "awd", name: "Plan 3"),
//    Plan(id: "awd", name: "Plan 4"),
//    Plan(id: "awd", name: "Plan 5"),
//    Plan(id: "awd", name: "Plan 6"),
//    Plan(id: "awd", name: "Plan 7"),
//    Plan(id: "awd", name: "Plan 8"),
//    Plan(id: "awd", name: "Plan 9")]
var friends = ["John", "Emma", "Liam"]


struct ContentView: View {
    @EnvironmentObject var cloudService: CloudService
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
            .background(AssetsManager.background1)
            .shadow(color: AssetsManager.shadowColor, radius: 5)
        }
        .background(AssetsManager.background2)
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
                    .foregroundColor(selectedTab == tab ? AssetsManager.accent1 : AssetsManager.gray1)
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
                .foregroundColor(AssetsManager.text1)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .navigationBarTitle("Stats", displayMode: .inline)
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Your Workout Today")
                .foregroundColor(AssetsManager.text1)
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
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
