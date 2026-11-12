//
//  CustomButton.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//

import SwiftUI

public struct CustomButton: View {

    public enum Style {
        case primary
        case secondary
        case icon
    }

    private let title: String?
    private let icon: String?
    private let style: Style
    private let isFullWidth: Bool
    private let isDisabled: Bool
    private let action: () -> Void

    public init(title: String? = nil, icon: String? = nil, style: Style = .primary, isFullWidth: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isFullWidth = isFullWidth
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            buttonContent
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.45 : 1)
    }

    @ViewBuilder
    private var buttonContent: some View {
        if style == .icon {
            iconLabel
        } else {
            textLabel
        }
    }

    private var iconLabel: some View {
        Image(systemName: icon ?? "circle")
            .font(.body.weight(.medium))
            .foregroundStyle(AppTheme.deepPurple)
            .frame(width: 40, height: 40)
            .background(Circle().fill(AppTheme.surface))
            .shadow(color: AppTheme.purple.opacity(0.18), radius: 5, y: 2)
    }

    private var textLabel: some View {
        HStack(spacing: 8) {
            if let icon { Image(systemName: icon) }
            if let title { Text(title).font(.subheadline.weight(.semibold)) }
        }
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .foregroundStyle(style == .primary ? Color.white : AppTheme.deepPurple)
        .background(textBackground)
    }

    @ViewBuilder
    private var textBackground: some View {
        if style == .primary {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(AppTheme.gradient)
        } else {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppTheme.surface)
                .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.purple, lineWidth: 1.4))
        }
    }
}
