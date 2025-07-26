//
//  InstagramSwipeContainer.swift
//  ChaosClinic
//
//  Created by Manas Malla on 24/07/25.
//


import SwiftUI

struct InstagramSwipeContainer<MainView: View, SideView: View>: View {
    let mainView: () -> MainView
    let sideView: () -> SideView

    @State private var offset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width

            ZStack(alignment: .leading) {
                // Side (DM) View
                sideView()
                    .frame(width: screenWidth)

                // Main (Feed) View
                mainView()
                    .frame(width: screenWidth)
                    .offset(x: offset + dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                // Allow only right swipe
                                if value.translation.width > 0 {
                                    state = value.translation.width
                                }
                            }
                            .onEnded { value in
                                let threshold = screenWidth / 3
                                if value.translation.width > threshold {
                                    // Snap to DMs
                                    offset = screenWidth
                                } else {
                                    // Snap back to Feed
                                    offset = 0
                                }
                            }
                    )
                    .animation(.interactiveSpring(), value: offset)
            }
            .ignoresSafeArea()
        }
    }
}
