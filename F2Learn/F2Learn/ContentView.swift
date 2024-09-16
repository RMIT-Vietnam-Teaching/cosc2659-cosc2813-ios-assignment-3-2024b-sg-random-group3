// ContentView.swift
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
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .navigationTitle("Welcome")
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


