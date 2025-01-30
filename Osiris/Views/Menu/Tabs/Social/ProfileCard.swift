//
//  ProfileCard.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/14/25.
//

import SwiftUI

struct ProfileCard: View {
    @EnvironmentObject var cloudService: CloudService
    @State var profile: Profile
    var type: ConnectionType
    @Binding var profileInView: Profile?
    
//    init(_ profile: Profile) {
//        self.profile = profile
//    }
    
    var body: some View {
        //Section {
        HStack {
            Section{
                //Button(action: {profileInView = profile}) {
                    Text(profile.nickname.first?.uppercased() ?? "?")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(AssetsManager.text1)
                        .frame(width: 56, height: 56)
                        .background(AssetsManager.gray1)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.nickname)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(profile.username)
                            .font(.footnote)
                            .accentColor(AssetsManager.gray2)
                    }
                //}
                Spacer()
            }
            switch type {
            case .friend:
                ForEach(profile.trophies, id: \.self) { trophy in
                    // will add later
                    Image(systemName: trophy)
                        .font(.subheadline)
                    Spacer()
                }
                RemoveButton(profile: $profile)
            case .inbound:
                AddButton(profile: $profile)
                RemoveButton(profile: $profile)
            case .outbound:
                RemoveButton(profile: $profile)
            case .blocked:
                Text("")
            case .cached:
                Text("")
            }
            
        }
        //}
    }
}

struct AddButton: View {
    @EnvironmentObject var cloudService: CloudService
    @Binding var profile: Profile
    var body: some View {
        Section{
            Button(action: {Task{await cloudService.profile.queueChange(forID: profile.id, change: .add)}}) {
                Image(systemName: "checkmark.square.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
                    .padding(10)
            }
            .buttonStyle(.borderless)
        }
    }
}

struct RemoveButton: View {
    @EnvironmentObject var cloudService: CloudService
    @Binding var profile: Profile
    var body: some View {
        Section {
            Button(action: {Task{await cloudService.profile.queueChange(forID: profile.id, change: .remove)}}) {
                Image(systemName: "multiply.square.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
                    .padding(10)
            }
            .buttonStyle(.borderless)
        }
    }
}


struct UserCard: View {
    var user: User
    
    var body: some View {
        Section {
            HStack {
                Text(user.initial)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(AssetsManager.text1)
                    .frame(width: 72, height: 72)
                    .background(AssetsManager.gray1)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.nickname)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 4)
                    Text(user.email)
                        .font(.footnote)
                        .accentColor(AssetsManager.gray2)
                }
            }
        }
    }
}
