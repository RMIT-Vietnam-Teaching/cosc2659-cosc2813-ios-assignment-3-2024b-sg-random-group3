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
        background: Color.white,
        surface: Color(hex: "F5F5F5"),
        onPrimary: Color.white,
        onSecondary: Color.black,
        onBackground: Color.black,
        onSurface: Color.black,
        accent: Color(hex: "FF9500")
    )
    
    static let dark = AppColors(
        primary: Color(hex: "64B5F6"),
        secondary: Color(hex: "4DB6AC"),
        background: Color.black,
        surface: Color(hex: "1E1E1E"),
        onPrimary: Color.black,
        onSecondary: Color.black,
        onBackground: Color.white,
        onSurface: Color.white,
        accent: Color(hex: "FFB74D")
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
