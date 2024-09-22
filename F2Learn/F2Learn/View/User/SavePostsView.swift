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

struct SavedPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
//            List(postViewModel.savedPosts) { post in
//                PostRow(post: post)
//            }
//            .navigationTitle("Saved Posts")
//            .onAppear {
//                if let userId = authViewModel.currentUser?.id {
//                    postViewModel.fetchSavedPosts(userId: userId)
//                }
//            }
        }
    }
}
    
