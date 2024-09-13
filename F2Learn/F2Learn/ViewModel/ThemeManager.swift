import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "IsDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "IsDarkMode")
    }
    
    var colors: AppColors {
        isDarkMode ? ColorScheme.dark : ColorScheme.light
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}
