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
    