import SwiftUI

extension Color {
    static var primaryColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.primary : ColorScheme.light.primary
    }
    
    static var secondaryColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.secondary : ColorScheme.light.secondary
    }
    
    static var backgroundColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.background : ColorScheme.light.background
    }
    
    static var surfaceColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.surface : ColorScheme.light.surface
    }
    
    static var onPrimaryColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.onPrimary : ColorScheme.light.onPrimary
    }
    
    static var onSecondaryColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.onSecondary : ColorScheme.light.onSecondary
    }
    
    static var onBackgroundColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.onBackground : ColorScheme.light.onBackground
    }
    
    static var onSurfaceColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.onSurface : ColorScheme.light.onSurface
    }
    
    static var accentColor: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? ColorScheme.dark.accent : ColorScheme.light.accent
    }
}
