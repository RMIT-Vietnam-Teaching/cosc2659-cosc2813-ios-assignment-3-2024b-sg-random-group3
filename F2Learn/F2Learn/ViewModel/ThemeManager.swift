import SwiftUI

enum Theme: String {
    case light, dark
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "AppTheme")
        }
    }
    
    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "AppTheme"),
           let theme = Theme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .light
        }
    }
    
    var colors: AppColors {
        currentTheme == .light ? ColorScheme.light : ColorScheme.dark
    }
    
    func toggleTheme() {
        currentTheme = currentTheme == .light ? .dark : .light
    }
}
