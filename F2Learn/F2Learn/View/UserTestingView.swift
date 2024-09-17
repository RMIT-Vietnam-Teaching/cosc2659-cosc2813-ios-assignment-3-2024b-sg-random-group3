// User Details View for testing the user information from the database
import SwiftUI

struct UserTestingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("User Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let user = authViewModel.currentUser {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Full Name: \(user.fullname)")
                    Text("Email: \(user.email)")
                    Text("Phone: \(user.phone)")
                    Text("Role: \(user.role.rawValue)")
                    Text("Role: \(user.createdDate)")
                    Text("Role: \(user.lastActive)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            } else {
                Text("User information not available")
            }
            
            Button(action: logout) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func logout() {
        authViewModel.signOut()
    }
}
