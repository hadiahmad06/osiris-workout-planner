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
                    try await viewModel.signIn(
                        withEmail: self.email,
                        password: self.password)
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
            
            Button {
                showLoginView = false
            } label: {
                HStack{
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(AssetsManager.textColorSecondary)
            }
            Spacer()
        }
        .frame(minHeight: UIScreen.main.bounds.height)
        .background(AssetsManager.backgroundColor)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLoginView: .constant(true))
            .environmentObject(AuthViewModel.EXAMPLE_VIEW_MODEL)
    }
}
