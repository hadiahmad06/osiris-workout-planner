//
//  SetupView.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/18/24.
//

import SwiftUI

struct SetupView: View {
    @State private var selectedPrompt: SetupOption = .goals
    
    enum SetupOption {
        case goals, gym, friends, ai
    }
    
    var body: some View {
        VStack {
            switch selectedPrompt {
            case .goals:
                GoalsView()
            case .gym:
                GymView()
            case .friends:
                FriendsView()
            case .ai:
                AIView()
            }
            HStack {
                
                if selectedPrompt != .goals {
                    Button(action: {
                        switch selectedPrompt {
                        case .gym:
                            selectedPrompt = .goals
                        case .friends:
                            selectedPrompt = .gym
                        case .ai:
                            selectedPrompt = .friends
                        default:
                            selectedPrompt = .goals
                        }
                    }) {
                        ZStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20))
                                .foregroundStyle(AssetsManager.textColor)
                                .padding(40)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                if selectedPrompt != .ai {
                    Button(action: {
                        switch selectedPrompt {
                        case .goals:
                            selectedPrompt = .gym
                        case .gym:
                            selectedPrompt = .friends
                        case .friends:
                            selectedPrompt = .ai
                        case .ai:
                            break
                        }
                    }) {
                        ZStack {
                            Text("Skip")
                                .font(.system(size: 20))
                                .foregroundStyle(AssetsManager.textColor)
                                .padding(40)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                }
            }
            Spacer()
            // Current Prompt based on selected setup option
            
        }
        .background(AssetsManager.backgroundColor)
    }
}

struct GoalsView: View {
    var body: some View {
        VStack{
            Text("Create Goals")
                .font(.system(size: 20))
                .foregroundColor(AssetsManager.textColor)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            Spacer()
        }
        .padding()
    }
}

struct GymView: View {
    var body: some View {
        VStack{
            Text("gym")
        }
    }
}

struct FriendsView: View {
    var body: some View {
        VStack{
            Text("friends")
        }
    }
}

struct AIView: View {
    var body: some View {
        VStack{
            Text("ai")
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
