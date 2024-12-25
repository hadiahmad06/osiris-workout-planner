//
//  ControllerView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct ControllerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showLoginView: Bool = false
    
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ContentView()
            } else {
                if(showLoginView) {
                    LoginView(showLoginView: $showLoginView)
                } else {
                    RegistrationView(showLoginView: $showLoginView)
                }
            }
        }
        //.edgesIgnoringSafeArea(.all)
    }
}

//extension ControllerView {
//    static var EXAMPLE_CONTROLLER_VIEW: ControllerView = ControllerView()
//}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
