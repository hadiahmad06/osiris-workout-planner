//
//  ExerciseSliderView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 2/21/25.
//

import SwiftUI

struct ExerciseSliderView: View {
    @EnvironmentObject var localService: LocalService
    
    var entries: [ExerciseEntryUI]
    @Binding var selectedIndex: Int
    @Binding var updateView: Bool
    
    // for snapping
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var dragVelocity: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.8
            let cardHeight = geometry.size.height
            let cardSpacing: CGFloat = -15
            let totalCardWidth = cardWidth + cardSpacing
            HStack(spacing: cardSpacing) {
                ForEach(entries.indices, id: \.self) { index in
                    VStack {
                        HStack {
                            Text(entries[index].exercise.name)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(25)
                            
                            Spacer()
                            
                            Button(action: {
                                localService.removeExercise(selectedIndex)
                                if selectedIndex != 0 { selectedIndex -= 1 }
                            }) {
                                Image(systemName: "multiply.square.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.red)
                            }
                            .padding(25)
                        }
                        Spacer()
                        VStack {
                            SetsView(entry: entries[index])
                            
                            Button(action: { localService.addSet() }) {
                                Image(systemName: "plus.rectangle.fill")
                                    .foregroundColor(AssetsManager.accent1)
                                    .font(.system(size: 22))
                                    .shadow(radius: 3)
                            }
                            .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                    .frame(width: cardWidth, height: cardHeight)
                    .background(AssetsManager.background3)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3), value: selectedIndex)
                    .onTapGesture {
                        if selectedIndex != index {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                offset = -CGFloat(index) * totalCardWidth
                                selectedIndex = index
                            }
                        }
                    }
                    .scaleEffect(index == selectedIndex ? 1.0 : 0.85)
                    .id(index)
                }
            }
            .padding(.horizontal, (geometry.size.width - cardWidth) / 2)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // manually drag view
                        offset = value.translation.width + lastOffset
                        dragVelocity = value.velocity.width * 2
                    }
                    .onEnded { value in
                        // snaps to card
                        let proposedSnapIndex = Int(round((-offset) / totalCardWidth))
                        // stops when user slides past left and rightmost cards
                        let validSnapIndex = max(0, min(proposedSnapIndex, entries.count - 1))
                        
                        let newOffset = -CGFloat(validSnapIndex) * totalCardWidth
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                            offset = newOffset
                            selectedIndex = validSnapIndex
                        }
                        
                        lastOffset = offset
                    }
            )
        }
        .onChange(of: selectedIndex) { _, newValue in
            localService.navigate(toIdx: newValue)
            print(localService.workout.selectedExercise?.base.order ?? "none selected?")
        }
        .onReceive(NotificationCenter.default.publisher(for: .workoutUpdated)) { _ in
            updateView.toggle()
        }
        .id(updateView)
    }
}
