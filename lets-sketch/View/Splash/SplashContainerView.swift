//
//  SplashContainerView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 23/09/2026.
//


import SwiftUI

struct SplashContainerView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            RootView()

            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.5))

            withAnimation(.easeOut(duration: 0.35)) {
                showSplash = false
            }
        }
    }
}
