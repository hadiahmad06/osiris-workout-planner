//
//  ContentView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/17/24.
//

import SwiftUI

var friends = ["John", "Emma", "Liam"]


struct ContentView: View {
    @EnvironmentObject var cloudService: CloudService
    @State private var selectedTab: Tab = .today
    static var tabMenuHeight: CGFloat = 75
    static var allowedHeight: CGFloat = UIScreen.main.bounds.height - ContentView.tabMenuHeight
    
    enum Tab {
        case stats, social, today, plan, settings
    }
    
    var body: some View {
        VStack {
            Group {
                switch selectedTab {
                case .stats: StatsView()
                case .social: SocialView()
                case .today: TodayView()
                case .plan: HomeView()
                case .settings: SettingsView()
                }
            }
            .frame(maxHeight: ContentView.allowedHeight)

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
            .frame(maxHeight: ContentView.tabMenuHeight)
            .background(AssetsManager.background1)
        }
        .background(AssetsManager.background2)
    }
}

struct TabButton: View {
    var tab: ContentView.Tab
    @Binding var selectedTab: ContentView.Tab
    var isMainButton: Bool = false
    
    var body: some View {
        Button(action: { selectedTab = tab }) {
            VStack {
                Image(systemName: iconName(for: tab))
                    .font(.system(size: isMainButton ? 32 : 24))
                    .foregroundColor(selectedTab == tab ? AssetsManager.accent1 : AssetsManager.gray1)
            }
            .frame(width: 48, height: 48)
        }
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
