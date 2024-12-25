//
//  LoginView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/22/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            AssetsManager.logo
                .resizable()
                .scaledToFill()
                .frame(width:100, height:100)
                .foregroundStyle(AssetsManager.accentColorMain)
                .padding(.vertical, 50)
            VStack{
                InputView(text: $email,
                          placeholder: "Email")
                
                InputView(text: $password,
                          placeholder: "Password",
                          isSecureField: true)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            .background(AssetsManager.backgroundAccent)
            .cornerRadius(25)
            .padding(.horizontal, 40)
            
            Button(action: {
                Task {
                    try await viewModel.signIn(withEmail: email, password: password)
                }
            }) {
                HStack {
                    Text("SIGN IN")
                        .font(.system(size: 20))
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(AssetsManager.buttonTextColor)
            }
            .frame(width: 200, height: 50)
            .background(AssetsManager.buttonColor)
            .cornerRadius(24)
            .padding(.top, 30)
            
            Spacer()
            
            NavigationLink { // NOT COMPLETE
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack{
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(AssetsManager.textColorSecondary)
            }
            
        }
        .background(AssetsManager.backgroundColor)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
