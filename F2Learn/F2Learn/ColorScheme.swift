import SwiftUI

struct AppColors {
    let primary: Color
    let secondary: Color
    let background: Color
    let surface: Color
    let onPrimary: Color
    let onSecondary: Color
    let onBackground: Color
    let onSurface: Color
    let accent: Color
}

struct ColorScheme {
    static let light = AppColors(
        primary: Color(hex: "4A90E2"),
        secondary: Color(hex: "50E3C2"),
        background: Color(hex: "FFFFFF"),
        surface: Color(hex: "F5F5F5"),
        onPrimary: Color(hex: "FFFFFF"),
        onSecondary: Color(hex: "000000"),
        onBackground: Color(hex: "000000"),
        onSurface: Color(hex: "000000"),
        accent: Color(hex: "FF9500")
    )
    
    static let dark = AppColors(
        primary: Color(hex: "64B5F6"),
        secondary: Color(hex: "4DB6AC"),
        background: Color(hex: "121212"),
        surface: Color(hex: "1E1E1E"),
        onPrimary: Color(hex: "000000"),
        onSecondary: Color(hex: "000000"),
        onBackground: Color(hex: "FFFFFF"),
        onSurface: Color(hex: "FFFFFF"),
        accent: Color(hex: "FFB74D")
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
