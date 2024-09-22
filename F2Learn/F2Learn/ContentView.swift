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

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreenView(isActive: $isShowingSplash)
            } else {
                mainContent
            }
        }
    }
    
    var mainContent: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.currentUser?.role == .admin {
                    AdminDashboardView(viewModel: AdminDashboardViewModel(authViewModel: authViewModel))
                } else {
                    UserDashboardView()
                }
            } else {
                WelcomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
