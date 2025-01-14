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
    @EnvironmentObject var cloudService: CloudService
    @Binding var showLoginView: Bool
    @State private var authErrorMessage: String = ""
    
    func updateErrorMessage() {
        self.authErrorMessage = cloudService.authErrorMessage
    }
    
    var body: some View {
        //Group {
            VStack{
                InputView(text: $email,
                          placeholder: "Email",
                          caseSensitive: false)
                
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
                    try await cloudService.signIn(
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
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .background(AssetsManager.buttonColor)
            .cornerRadius(24)
            .padding(.top, 30)
            
            Text(authErrorMessage)
                .onAppear {
                    updateErrorMessage()
                }
                .foregroundStyle(Color.red)
                .fontWeight(.bold)
                .padding(.top, 10)
            
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
            .padding(.bottom, 100)
            
              
        }
    //}
}

extension LoginView {
    var formIsValid: Bool {
        return !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty
        && password.count >= 6
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLoginView: .constant(true))
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
