import SwiftUI
import Firebase

@main
struct F2LearnApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
}
