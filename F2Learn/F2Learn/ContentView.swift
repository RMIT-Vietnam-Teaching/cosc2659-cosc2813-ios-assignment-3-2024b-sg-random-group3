import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isAuthenticated {
                    if authViewModel.currentUser?.role == .admin {
                        AdminDashboardView(viewModel: AdminDashboardViewModel(authViewModel: authViewModel))
                    } else {
                        UserDetailsView()
                    }
                } else {
                    VStack(spacing: 20) {
                        // Login Button
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("primarycolor")) // Primary color from assets
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // Sign Up Button
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("secondarycolor")) // Secondary color from assets
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
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
        Group {
            // Unauthenticated
            ContentView()
                .environmentObject(mockUnauthenticatedViewModel())
                .previewDisplayName("Unauthenticated")
            
            // Admin
            ContentView()
                .environmentObject(mockAdminViewModel())
                .previewDisplayName("Admin")
            
            // Regular User
            ContentView()
                .environmentObject(mockUserViewModel())
                .previewDisplayName("User")
        }
    }
    
    // Mock view models for preview
    static func mockUnauthenticatedViewModel() -> AuthViewModel {
        let vm = AuthViewModel()
        vm.isAuthenticated = false
        return vm
    }
    
    static func mockAdminViewModel() -> AuthViewModel {
        let vm = AuthViewModel()
        vm.isAuthenticated = true
        vm.currentUser = User(id: "admin_id", fullname: "Admin User", email: "s3911737@rmit.edu.vn", phone: "1234567890", role: .admin, createdDate: Date(), lastActive: Date())
        return vm
    }
    
    static func mockUserViewModel() -> AuthViewModel {
        let vm = AuthViewModel()
        vm.isAuthenticated = true
        vm.currentUser = User(id: "user_id", fullname: "Minh User", email: "minh@gmail.com", phone: "9876543210", role: .user, createdDate: Date(), lastActive: Date())
        return vm
    }
}
