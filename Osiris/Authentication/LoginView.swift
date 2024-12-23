//
//  LoginView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/22/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            InputView(text: $username,
                      placeholder: "Email")
            
            InputView(text: $password,
                      placeholder: "Password")
                
            Button(action: {}) {
                Text("Sign In")
                    .font(.system(size: 20))
            }
            .background(GlobalColorManager.buttonColor)
            .cornerRadius(24)
            .padding(.top, 24)
            Spacer()
        }
        .background(GlobalColorManager.backgroundColor)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
