import SwiftUI

extension Color {
    static func themed(_ keyPath: KeyPath<AppColors, Color>) -> Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .light ? ColorScheme.light[keyPath: keyPath] : ColorScheme.dark[keyPath: keyPath]
    }
    
    static var primaryColor: Color { .themed(\.primary) }
    static var secondaryColor: Color { .themed(\.secondary) }
    static var backgroundColor: Color { .themed(\.background) }
    static var surfaceColor: Color { .themed(\.surface) }
    static var onPrimaryColor: Color { .themed(\.onPrimary) }
    static var onSecondaryColor: Color { .themed(\.onSecondary) }
    static var onBackgroundColor: Color { .themed(\.onBackground) }
    static var onSurfaceColor: Color { .themed(\.onSurface) }
    static var accentColor: Color { .themed(\.accent) }	
}
