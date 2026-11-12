//
//  CustomTextField.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//

import SwiftUI

public struct CustomTextField: View {

    private let placeholder: String
    @Binding private var text: String

    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextField(placeholder, text: $text)
            .font(.headline)
            .foregroundStyle(AppTheme.textPrimary)
            .padding(.vertical, 10)
            .padding(.horizontal, AppTheme.spacing)
            .background(fieldBackground)
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
            .fill(AppTheme.surface)
    }
    
}
