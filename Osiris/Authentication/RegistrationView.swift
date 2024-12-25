//
//  RegistrationView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/22/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var nickname: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var showLoginView: Bool


    var body: some View {
        VStack {
            Spacer()
            AssetsManager.logo
                .resizable()
                .scaledToFill()
                .frame(width:100, height:100)
                .foregroundStyle(AssetsManager.accentColorMain)
                .padding(.vertical, 50)
            VStack{
                InputView(text: $email,
                          placeholder: "Email")
                
                InputView(text: $username,
                          placeholder: "Username")
                
                InputView(text: $nickname,
                          placeholder: "Nickname")
                
                InputView(text: $password,
                          placeholder: "Password",
                          isSecureField: true)
            }
            .padding(.horizontal, 15)
            .padding(.top, 12)
            .background(AssetsManager.backgroundAccent)
            .cornerRadius(25)
            .padding(.horizontal, 50)
            
            Button(action: {
                Task {
                    try await viewModel.signIn(
                        withEmail: self.email,
                        password: self.password)
                }
                Task {
                    try await viewModel.createUser(
                        withEmail: self.email,
                        password: self.password,
                        username: self.username,
                        nickname: self.nickname)
                }
            }) {
                HStack {
                    Text("SIGN UP")
                        .font(.system(size: 20))
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(AssetsManager.buttonTextColor)
            }
            .frame(width: 225, height: 50)
            .background(AssetsManager.buttonColor)
            .cornerRadius(24)
            .padding(.top, 30)
            
            Spacer()
            
            Button {
                showLoginView = true
            } label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign in!")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(AssetsManager.textColorSecondary)
            }
            Spacer()
        }
        .frame(maxHeight: UIScreen.main.bounds.height)
        .background(AssetsManager.backgroundColor)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showLoginView: .constant(false))
            .environmentObject(AuthViewModel.EXAMPLE_VIEW_MODEL)
    }
}
