//
//  Sliding.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import SwiftUI

struct Animations {
    func slideViews<View1: View, View2: View>(
        view1: View1,
        view2: View2,
        animationTime: CGFloat,
        state: Binding<Bool>
    ) -> some View {
        static private var position = UIScreen.main.bounds.width / 2
        @State private var posOffset = position
        @State private var __state = state.wrappedValue
        
        ZStack {
            // View1
            if state || __state {
                VStack {
                    View1(showLoginView: $__state)
                        .offset(x: position + posOffset)
                }
            }
            // RegistrationView
            if !state || !__state {
                VStack {
                    View2(showLoginView: $__state)
                        .offset(x: -position + posOffset)
                }
            }
        }
        .onChange(of: __state) { oldValue, newValue in
            // guarantees that unselected view remains rendered during animation
            state = oldValue
            
            // if switching to registration view
            if oldValue {
                withAnimation(.easeInOut(duration: animationTime)) {
                    posOffset = position
                }
            // if switching to login view
            } else {
                withAnimation(.easeInOut(duration: animationTime)) {
                    posOffset = -1 * position
                }
            }
            // unrenders unselected view after the animation is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                state = newValue
                
            }
        }
    }
}
