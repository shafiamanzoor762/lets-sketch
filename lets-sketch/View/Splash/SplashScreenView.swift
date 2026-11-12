//
//  SplashScreenView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//

import SwiftUI
import CustomViews

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.85

    var body: some View {
        ZStack {
            AppTheme.gradient
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "scribble.variable")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(.white)

                Text(AppStrings.appName)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.splashTagline)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.85))
            }
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                scale = 1.0
            }
        }
    }
}
