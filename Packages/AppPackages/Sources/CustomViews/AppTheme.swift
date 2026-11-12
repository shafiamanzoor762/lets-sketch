import SwiftUI

public enum AppTheme {
    public static let babyPink = Color(red: 0.97, green: 0.80, blue: 0.86)
    public static let softPink = Color(red: 0.99, green: 0.90, blue: 0.93)
    public static let lavender = Color(red: 0.82, green: 0.78, blue: 0.95)
    public static let purple = Color(red: 0.58, green: 0.42, blue: 0.78)
    public static let deepPurple = Color(red: 0.37, green: 0.22, blue: 0.55)

    public static let background = Color(uiColor: .systemGroupedBackground)
    public static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    public static let canvasSurface = Color(uiColor: .systemBackground)
    public static let textPrimary = Color(uiColor: .label)
    public static let textSecondary = Color(uiColor: .secondaryLabel)

    public static let gradient = LinearGradient(
        colors: [babyPink, purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let cornerRadius: CGFloat = 18
    public static let smallCornerRadius: CGFloat = 12
    public static let spacing: CGFloat = 16
}
