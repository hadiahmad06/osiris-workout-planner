//
//  SlideViews.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/30/25.
//

import SwiftUI

struct SlideViews<View1: View, View2: View>: View {
    private var view1: View1
    private var view2: View2
    private var animationTime: CGFloat
    private var direction: Axis
    @Binding var showView1: Bool
    
    @State private var __showView1: Bool = false
    private var position: CGFloat
    @State private var posOffset: CGFloat
    
    init(view1: View1, view2: View2, animationTime: CGFloat, direction: Axis = .vertical, showView1: Binding<Bool>) {
        self.view1 = view1
        self.view2 = view2
        self.animationTime = animationTime
        self.direction = direction
        self._showView1 = showView1
        
        let screen = UIScreen.main.bounds
        let pos = direction == .horizontal ? screen.width / 2 : screen.height / 2
        self.position = pos
        self.posOffset = pos
    }
    
    var body: some View {
        ZStack {
            // View1
            if showView1 || __showView1 {
                VStack {
                    view1
                        .offset(x: direction == .horizontal ? position + posOffset : 0,
                                y: direction == .vertical ? position + posOffset : 0)
                }
            }
            // View2
            if !showView1 || !__showView1 {
                VStack {
                    view2
                        .offset(x: direction == .horizontal ? -position + posOffset : 0,
                                y: direction == .vertical ? -position + posOffset : 0)
                }
            }
        }
        .onChange(of: showView1) { oldValue, newValue in
            // guarantees that unselected view remains rendered during animation
            __showView1 = oldValue
            
            // if switching to View2
            if oldValue {
                withAnimation(.easeInOut(duration: animationTime)) {
                    posOffset = position
                }
            // if switching to View1
            } else {
                withAnimation(.easeInOut(duration: animationTime)) {
                    posOffset = -position
                }
            }
            // unrenders unselected view after the animation is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                __showView1 = newValue
            }
        }
        .onAppear() {
            __showView1 = $showView1.wrappedValue
        }
    }
}
