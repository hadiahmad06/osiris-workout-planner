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
                
                InputView(text: $username,
                          placeholder: "Username",
                          caseSensitive: false)
                
                InputView(text: $nickname,
                          placeholder: "Nickname")
                
                InputView(text: $password,
                          placeholder: "Password",
                          isSecureField: true)
            }
            .padding(.horizontal, 15)
            .padding(.top, 12)
            .background(AssetsManager.background2)
            .cornerRadius(25)
            .padding(.horizontal, 50)
            
            Button(action: {
                //                Task {
                //                    try await viewModel.signIn(
                //                        withEmail: self.email,
                //                        password: self.password)
                //                }
                Task {
                    try await cloudService.createUser(
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
                .foregroundStyle(AssetsManager.white)
            }
            .frame(width: 225, height: 50)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .background(AssetsManager.button)
            .cornerRadius(24)
            .padding(.top, 30)
            
            Text(authErrorMessage)
                .onAppear {
                    updateErrorMessage()
                }
                .foregroundStyle(Color.red)
                .fontWeight(.bold)
                .padding(.top, 10)
                .frame(alignment: .center)
            
            Spacer()
            
            Button {
                showLoginView = true
            } label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign in!")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(AssetsManager.text2)
            }
            .padding(.bottom, 100)
        }
        //.transition(.move(edge: .leading))
        
    //}
}

extension RegistrationView {
    var formIsValid: Bool {
        return !email.isEmpty &&
        email.contains("@") &&
        !username.isEmpty &&
        !nickname.isEmpty &&
        !password.isEmpty &&
        password.count >= 6
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showLoginView: .constant(false))
            .environmentObject(CloudService.EXAMPLE_CLOUD_SERVICE)
    }
}
