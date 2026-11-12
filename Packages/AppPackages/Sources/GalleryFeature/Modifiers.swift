//
//  Modifiers.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 24/06/2026.
//

import SwiftUI

struct CustomNavigationSetup<Destination: View>: ViewModifier {
    let title: String
    let displayMode: NavigationBarItem.TitleDisplayMode
    @Binding var isPresented: Bool
    @ViewBuilder let destination: () -> Destination

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode)
            .navigationDestination(isPresented: $isPresented, destination: destination)
    }
}

extension View {
    func setupCustomNavigation<Destination: View>(
        title: String,
        displayMode: NavigationBarItem.TitleDisplayMode = .inline,
        isPresented: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        modifier(
            CustomNavigationSetup(
                title: title,
                displayMode: displayMode,
                isPresented: isPresented,
                destination: destination
            )
        )
    }
}
