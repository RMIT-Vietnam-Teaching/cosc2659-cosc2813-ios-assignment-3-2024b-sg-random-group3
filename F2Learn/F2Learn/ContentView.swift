import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreenView(isActive: $isShowingSplash)
            } else {
                mainContent
            }
        }
    }
    
    var mainContent: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.currentUser?.role == .admin {
                    AdminDashboardView(viewModel: AdminDashboardViewModel(authViewModel: authViewModel))
                } else {
                    UserDashboardView()
                }
            } else {
                WelcomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
