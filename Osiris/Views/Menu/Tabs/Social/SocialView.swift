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
    @State private var socialErrorMessage: String = ""
    @State private var list: [Profile] = []
    @State var profileInView: Profile?
//    @State private var inView: Bool = false // MIGHT CHANGE LATER
    
    private func updateErrorMessage() {
        socialErrorMessage = cloudService.profile.socialErrorMessage
    }
    
    var body: some View {
        VStack {
            // list selection
            HStack{
                SwitchSocialListButton(view: $currentView, newView: .friend, text: "Friends")
                SwitchSocialListButton(view: $currentView, newView: .inbound, text: "Incoming")
                SwitchSocialListButton(view: $currentView, newView: .outbound, text: "Outgoing")
            }
            .padding()
            
            // list of friends, incoming, or outgoing
            if list.isEmpty {
                Spacer()
                switch currentView {
                case .friend:
                    Text("Couldn't load friends. Try adding a friend below!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                case .inbound:
                    Text("No incoming requests.")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                case .outbound:
                    Text("You haven't sent any requests yet. Try adding a friend below!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                default:
                    Text("how did you get here dawg")
                }
                Spacer()
            } else {
                List(list) { profile in
                    ProfileCard(profile: profile,
                                type: currentView,
                                profileInView: $profileInView)
                }
                .background(AssetsManager.background2)
                .scrollContentBackground(.hidden)
            }
            
            
            // error message
            Text(socialErrorMessage)
            .onAppear {
                updateErrorMessage()
            }
            .onReceive(NotificationCenter.default.publisher(for: .socialErrorMessageChanged)) {_ in
                updateErrorMessage()
            }
            .foregroundStyle(Color.red)
            .fontWeight(.bold)
            
            // add new friend
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
        .onAppear { getList() }
        .onChange(of: currentView) { getList() }
        .onReceive(NotificationCenter.default.publisher(for: .connectionsParsed)) {_ in
            getList()
        }
//        .slideViews(to: ProfileView(profile: $profileInView), when: $inView)
        //        .navigationBarTitle("Social", displayMode: .inline)
//        .onChange(of: profileInView) { _, newValue in
//            inView = newValue != nil
//        }
    }
    
    private func getList() {
        switch currentView {
        case .friend:
            list = cloudService.profile.friends
        case .inbound:
            list = cloudService.profile.inRequests
        case .outbound:
            list = cloudService.profile.outRequests
        case .blocked:
            list = cloudService.profile.blocked
        case .cached:
            list = []
        }
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

// from https://github.com/GeorgeElsham on stackoverflow.com
// used in SocialView
//extension View {
//    func slideViews<NewView: View>(to view: NewView, profile bound: Binding<Profile>) -> some View {
//        ZStack {
//            if bound.wrappedValue == nil {
//                self
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)
//            }
//            if bound.wrappedValue != nil {
//                view
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)
//        }
//        .onChange(of: bound.wrappedValue) { _, newValue in
//            if !newValue {
//                
//            }
//        }
//    }
//}
