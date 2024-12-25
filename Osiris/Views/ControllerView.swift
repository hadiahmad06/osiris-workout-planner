//
//  ControllerView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct ControllerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ContentView()
            } else {
                RegistrationView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
