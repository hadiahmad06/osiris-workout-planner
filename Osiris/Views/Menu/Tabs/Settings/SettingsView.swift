//
//  SettingsView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var cloudService: CloudService
    
    var body: some View {
        VStack {
            if let user = cloudService.currentUser {
                List {
                    UserCard(user: user)
                    .listRowBackground(AssetsManager.background3)
                    Section("GENERAL") {
                        HStack {
                            SettingsRowView(imageName: "gear",
                                            title: "Version",
                                            color: AssetsManager.text1)
                            Spacer()
                            Text(AppInfo.version)
                                .font(.subheadline)
                                .accentColor(AssetsManager.gray2)
                        }
                        
                    }
                    .listRowBackground(AssetsManager.background3)
                    Section("ACCOUNT") {
                        Button(action: { Task { cloudService.signOut() } }) {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            color: .red)
                        }
                        Button(action: { Task { await cloudService.deactivateAccount() } }) {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Deactivate Account",
                                            color: .red)
                        }
                    }
                    .listRowBackground(AssetsManager.background3)
                }
                .background(AssetsManager.background2)
                .scrollContentBackground(.hidden)
            }
        }
        //.navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
