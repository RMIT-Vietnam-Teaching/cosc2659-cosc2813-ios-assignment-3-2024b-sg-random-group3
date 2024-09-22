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
