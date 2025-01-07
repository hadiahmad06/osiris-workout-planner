//
//  ControllerView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct ControllerView: View {
    @EnvironmentObject var cloudService: CloudService
    @State private var showLoginView: Bool
    
    init() {
        showLoginView = false
    }
    
    var body: some View {
        Group {
            if cloudService.auth.userSession != nil {
                AnyView(ContentView())
                    .onAppear(perform: {
                        cloudService.auth.authErrorMessage = ""
                    })
            } else {
                if(showLoginView) {
                    AnyView(LoginView(showLoginView: $showLoginView))
                } else {
                    AnyView(RegistrationView(showLoginView: $showLoginView))
                }
            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
