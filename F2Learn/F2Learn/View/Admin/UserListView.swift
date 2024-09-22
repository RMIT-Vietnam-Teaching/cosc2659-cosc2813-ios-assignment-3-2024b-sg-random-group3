/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Random Group 3/F2 Learn
  ID: Tran Ngoc Minh – s3911737
      Nguyen Duong Truong Thinh – s3914412
      Dang Minh Triet – s4022878
      Du Tuan Vu – s3924489
  Created  date:  26/08/2024
  Last modified:  23/09/2024
  Acknowledgement: RMIT Canvas( tutorials, modules)
*/


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

