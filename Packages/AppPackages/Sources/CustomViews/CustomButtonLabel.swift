//
//  CustomButtonLabel.swift
//  DesignSystem
//
//  Created by Shafia Manzoor on 30/06/2026.
//


import SwiftUI

public struct CustomButtonLabel: View {
    private let title: String
    private let icon: String
    private let style: CustomButton.Style

    public init(title: String, icon: String, style: CustomButton.Style) {
        self.title = title
        self.icon = icon
        self.style = style
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(title).font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .foregroundStyle(style == .primary ? Color.white : AppTheme.deepPurple)
        .background(
            Group {
                if style == .primary {
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(AppTheme.gradient)
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .fill(AppTheme.surface)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.purple, lineWidth: 1.4))
                }
            }
        )
    }
}
