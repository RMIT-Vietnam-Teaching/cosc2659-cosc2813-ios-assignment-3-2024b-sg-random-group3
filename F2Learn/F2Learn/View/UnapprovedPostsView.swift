import SwiftUI

struct UnapprovedPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        List(postViewModel.unapprovedPosts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                Text(post.content)
                    .font(.subheadline)
                    .lineLimit(2)
                Text("Author: \(post.authorName)")
                    .font(.caption)
                Button("Approve") {
                    approvePost(post)
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Unapproved Posts")
        .onAppear {
            postViewModel.fetchUnapprovedPosts()
        }
    }
    
    private func approvePost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.approvePost(postId: postId) { success in
            if success {
                // Refresh the list of unapproved posts
                postViewModel.fetchUnapprovedPosts()
            }
        }
    }
}
