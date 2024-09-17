import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isAuthenticated {
                    if authViewModel.currentUser?.role == .admin {
                        AdminDashboardView()
                    } else {
                        UserDetailsView()
                    }
                } else {
                    VStack(spacing: 40) {
                        // App Logo
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150) // Adjust size as needed
                            .padding(.top, 40)
                        
                        // Login Button
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .fontWeight(.semibold)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                .background(Color("primarycolor")) // Primary color from assets
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // Sign Up Button
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                .background(Color("secondarycolor")) // Secondary color from assets
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from assets
                    .navigationTitle("Welcome")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authenticatedViewModel = AuthViewModel()
        authenticatedViewModel.currentUser = User(
            id: "123",
            fullname: "John Doe",
            email: "john@example.com",
            phone: "1234567890",
            role: .user
        )
        authenticatedViewModel.isAuthenticated = true
        
        let unauthenticatedViewModel = AuthViewModel()
        
        return Group {
            ContentView()
                .environmentObject(authenticatedViewModel)
                .previewDisplayName("Authenticated")
            
            ContentView()
                .environmentObject(unauthenticatedViewModel)
                .previewDisplayName("Unauthenticated")
        }
    }
}
