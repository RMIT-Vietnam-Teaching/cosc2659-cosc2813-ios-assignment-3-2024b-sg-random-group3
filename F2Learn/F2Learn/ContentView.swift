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
