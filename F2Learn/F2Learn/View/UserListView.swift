import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(user.fullname)
                            .font(.headline)
                            .foregroundColor(Color("primarycolor")) // Primary color for headline
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary) // Neutral color for email
                        
                        Text("Role: \(user.role.rawValue)")
                            .font(.caption)
                            .foregroundColor(Color("secondarycolor")) // Secondary color for role
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Manage Users")
        .onAppear {
            viewModel.fetchAllUsers()
        }
        .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from assets
    }
}

struct UserDetailView: View {
    let user: User
    @ObservedObject var viewModel: AdminDashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(user.fullname)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("primarycolor")) // Primary color for user name
            
            Text(user.email)
                .font(.title2)
                .foregroundColor(.secondary) // Neutral color for email
            
            Text("Role: \(user.role.rawValue)")
                .font(.title3)
                .foregroundColor(Color("secondarycolor")) // Secondary color for role
            
            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
}
