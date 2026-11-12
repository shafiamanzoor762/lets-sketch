import SwiftUI

public struct AppearanceToggle: View {
    @Binding private var isDarkMode: Bool

    public init(isDarkMode: Binding<Bool>) {
        _isDarkMode = isDarkMode
    }

    public var body: some View {
        Button {
            isDarkMode.toggle()
        } label: {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.body.weight(.semibold))
                .foregroundStyle(isDarkMode ? AppTheme.lavender : AppTheme.deepPurple)
                .frame(width: 40, height: 40)
                .background(AppTheme.surface, in: Circle())
        }
        .accessibilityLabel(isDarkMode ? AppStrings.lightMode : AppStrings.darkMode)
    }
}
