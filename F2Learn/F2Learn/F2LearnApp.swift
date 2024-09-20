import SwiftUI
import Firebase

@main
struct F2LearnApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
}
