//
//  AuthView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/7/25.
//

import SwiftUI

struct AuthView: View {
    
    @State private var showLoginView: Bool      // current selected view
    @State private var __showLoginView: Bool    // next in animation
    
    static private var position: CGFloat = UIScreen.main.bounds.width / 2
    @State private var posOffset: CGFloat = position
    
    static private var animationTime: CGFloat = 0.5
    
    init() {
        showLoginView = false
        __showLoginView = false
    }
    
    var body: some View {
        VStack{
            AssetsManager.logo
                .resizable()
                .scaledToFill()
                .frame(width:100, height:100)
                .foregroundStyle(AssetsManager.accentColorMain)
                .padding(.top, 80)
                .padding(.vertical, 50)
            ZStack {
                // LoginView
                if showLoginView || __showLoginView {
                    VStack {
                        LoginView(showLoginView: $__showLoginView)
                            .offset(x: AuthView.position + posOffset)
                    }
                }
                // RegistrationView
                if !showLoginView || !__showLoginView {
                    VStack {
                        RegistrationView(showLoginView: $__showLoginView)
                            .offset(x: -AuthView.position + posOffset)
                    }
                }
            }
            .onChange(of: __showLoginView) { oldValue, newValue in
                // guarantees that unselected view remains rendered during animation
                showLoginView = oldValue
                
                // if switching to registration view
                if oldValue {
                    withAnimation(.easeInOut(duration: AuthView.animationTime)) {
                        posOffset = AuthView.position
                    }
                // if switching to login view
                } else {
                    withAnimation(.easeInOut(duration: AuthView.animationTime)) {
                        posOffset = -1 * AuthView.position
                    }
                }
                // unrenders unselected view after the animation is complete
                DispatchQueue.main.asyncAfter(deadline: .now() + AuthView.animationTime) {
                    showLoginView = newValue
                    
                }
            }
        }
        .frame(minHeight: UIScreen.main.bounds.height)
        .background(AssetsManager.backgroundColor)
    }
}
