// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Center the content vertically

                Image("applogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Text("Welcome to the app")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("We're excited to help you book and manage your service appointments with ease.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("Create an account")
                        .font(.subheadline)
                        .foregroundColor(Color.blue)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all)) // White background
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


