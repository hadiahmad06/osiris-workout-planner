//
//  ControllerView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import SwiftUI

struct ControllerView: View {
    @EnvironmentObject var cloudService: CloudService
    
    var body: some View {
        Group {
            if cloudService.userSession != nil {
                ContentView()
                    .onAppear(perform: {cloudService.authErrorMessage = ""})
            } else {
                AuthView()
            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
