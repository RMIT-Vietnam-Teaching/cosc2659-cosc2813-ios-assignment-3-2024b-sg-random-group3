import SwiftUI

struct UserDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("User Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("primarycolor")) // Primary color from assets
            
            // User Information
            if let user = authViewModel.currentUser {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Full Name: \(user.fullname)")
                        .foregroundColor(.primary)
                    Text("Email: \(user.email)")
                        .foregroundColor(.secondary)
                    Text("Phone: \(user.phone)")
                        .foregroundColor(.secondary)
                    Text("Role: \(user.role.rawValue)")
                        .foregroundColor(.secondary)
                    Text("Created: \(user.createdDate, formatter: DateFormatter.shortDate)")
                        .foregroundColor(.secondary)
                    Text("Last Active: \(user.lastActive, formatter: DateFormatter.shortDate)")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white) // White background for user info
                .cornerRadius(10)
                .shadow(radius: 5)
            } else {
                Text("User information not available")
                    .foregroundColor(.red)
            }
            
            // Logout Button
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
        .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from assets
    }
    
    // Logout Action
    private func logout() {
        authViewModel.signOut()
    }
}

// Date Formatter for displaying dates
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
