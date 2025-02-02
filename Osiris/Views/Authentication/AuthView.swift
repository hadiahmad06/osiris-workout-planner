//
//  AuthView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/7/25.
//

import SwiftUI

struct AuthView: View {
    @State private var showLoginView: Bool = false   // when changing view
    
    init() {
        showLoginView = false
    }
    
    var body: some View {
        VStack{
            AssetsManager.logo
                .resizable()
                .scaledToFill()
                .frame(width:100, height:100)
                .foregroundStyle(AssetsManager.accent1)
                .padding(.top, 80)
                .padding(.vertical, 50)
            
            SlideViews(view1: RegistrationView(showLoginView: $showLoginView),
                       view2: LoginView(showLoginView: $showLoginView),
                       animationTime: 0.5,
                       direction: .horizontal,
                       showView2: $showLoginView)
        }
        .frame(minHeight: UIScreen.main.bounds.height)
        .background(AssetsManager.background1)
    }
}
