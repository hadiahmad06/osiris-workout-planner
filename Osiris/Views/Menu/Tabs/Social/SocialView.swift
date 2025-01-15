//
//  SocialView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/14/25.
//

import SwiftUI

struct SocialView: View {
    @EnvironmentObject var cloudService: CloudService
    @State private var currentView: ConnectionType = .friend
    @State private var inputUsername: String = ""
    
    var body: some View {
        VStack {
            HStack{
                SwitchSocialListButton(view: $currentView, newView: .friend, text: "Friends")
                SwitchSocialListButton(view: $currentView, newView: .inbound, text: "Incoming")
                SwitchSocialListButton(view: $currentView, newView: .outbound, text: "Outgoing")
            }
            .padding()
            let friends = cloudService.profile.friends
            if friends.isEmpty {
                Spacer()
                Text("Couldn't load friends. Try adding a friend below!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            } else {
                List(cloudService.profile.friends) { friend in
                    ProfileCard(profile: friend, type: .friend)
                }
                .background(AssetsManager.background2)
                .scrollContentBackground(.hidden)
            }
            HStack {
                Section {
                    InputView(text: $inputUsername,
                              placeholder: cloudService.profile.currentProfile?.username ?? "Enter Username",
                              caseSensitive: false)
                }
                Button(action: {Task{await cloudService.profile.queueChange(forUsername: inputUsername, change: .add)}}) {
                    Text("Add")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .foregroundColor(AssetsManager.white)
                        .background(AssetsManager.button)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarTitle("Social", displayMode: .inline)
    }
}

struct SwitchSocialListButton: View {
    @Binding var view: ConnectionType
    var newView: ConnectionType
    var text: String
    
    var body: some View {
        Spacer()
        Button(action: {view = newView} ) {
            let color = (view == newView) ? AssetsManager.button : AssetsManager.gray1
            Text(text)
                .foregroundStyle(AssetsManager.white)
                .font(.headline)
                .fontWeight(.light)
                .padding(5)
                .frame(maxWidth: UIScreen.main.bounds.width / 4)
                .background(color)
                .cornerRadius(10)
        }
        Spacer()
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
