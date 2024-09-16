import SwiftUI
struct UserListView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
                    VStack(alignment: .leading) {
                        Text(user.fullname)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                        Text("Role: \(user.role.rawValue)")
                            .font(.caption)
                    }
                }
            }
        }
        .navigationTitle("Manage Users")
        .onAppear {
            viewModel.fetchAllUsers()
        }
    }
}

