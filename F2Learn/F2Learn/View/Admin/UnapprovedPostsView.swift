import SwiftUI

struct UnapprovedPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State private var showingAnnouncement = false
    @State private var announcementMessage = ""
    
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
                HStack {
                    Button("Approve") {
                        approvePost(post)
                    }
                    .foregroundColor(.green)
                    
                    Button("Reject") {
                        rejectPost(post)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Unapproved Posts")
        .onAppear {
            postViewModel.fetchUnapprovedPosts()
        }
        .alert(isPresented: $showingAnnouncement) {
            Alert(title: Text("Announcement"), message: Text(announcementMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func approvePost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.approvePost(postId: postId) { success in
            if success {
                announcementMessage = "Post approved successfully!"
                showingAnnouncement = true
                postViewModel.fetchUnapprovedPosts()
            } else {
                announcementMessage = "Failed to approve post. Please try again."
                showingAnnouncement = true
            }
        }
    }
    
    private func rejectPost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.rejectPost(postId: postId) { success in
            if success {
                announcementMessage = "Post rejected successfully!"
                showingAnnouncement = true
                postViewModel.fetchUnapprovedPosts()
            } else {
                announcementMessage = "Failed to reject post. Please try again."
                showingAnnouncement = true
            }
        }
    }
}
