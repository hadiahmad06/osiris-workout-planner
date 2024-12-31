//
//  SettingsView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                List {
                    Section {
                        HStack { // example user
                            Text(user.initial)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(AssetsManager.textColor)
                                .frame(width: 72, height: 72)
                                .background(AssetsManager.backgroundColor)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.nickname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(AssetsManager.accentColorTertiary)
                            }
                        }
                    }
                    Section("GENERAL") {
                        HStack {
                            SettingsRowView(imageName: "gear",
                                            title: "Version",
                                            color: AssetsManager.textColor)
                            Spacer()
                            Text(DebugInfo.version)
                                .font(.subheadline)
                                .accentColor(AssetsManager.accentColorTertiary)
                        }
                        
                    }
                    Section("ACCOUNT") {
                        Button(action: { viewModel.signOut() }) {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            color: .red)
                        }
                        Button(action: { Task { await viewModel.deactivateAccount() } }) {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Deactivate Account",
                                            color: .red)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(AssetsManager.backgroundAccent)
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel.EXAMPLE_VIEW_MODEL)
    }
}
