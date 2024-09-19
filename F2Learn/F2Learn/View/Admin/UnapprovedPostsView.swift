import SwiftUI

struct UnapprovedPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State private var showingConfirmation = false
    @State private var confirmationMessage = ""
    @State private var postToApprove: Post?
    @State private var postToReject: Post?
    
    var body: some View {
        List(postViewModel.unapprovedPosts) { post in
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                Text(post.content)
                    .font(.subheadline)
                    .lineLimit(2)
                Text("Author: \(post.authorName)")
                    .font(.caption)
                Text("Category: \(post.subjectCategory.rawValue)")
                    .font(.caption)
                HStack {
                    Button(action: {
                        postToApprove = post
                        confirmationMessage = "Are you sure you want to approve this post?"
                        showingConfirmation = true
                    }) {
                        Text("Approve")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    
                    Button(action: {
                        postToReject = post
                        confirmationMessage = "Are you sure you want to reject this post?"
                        showingConfirmation = true
                    }) {
                        Text("Reject")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Unapproved Posts")
        .onAppear {
            postViewModel.fetchUnapprovedPosts()
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Action"),
                message: Text(confirmationMessage),
                primaryButton: .default(Text("Yes")) {
                    if let post = postToApprove {
                        approvePost(post)
                    } else if let post = postToReject {
                        rejectPost(post)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func approvePost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.approvePost(postId: postId) { success in
            if success {
                postViewModel.fetchUnapprovedPosts()
            }
        }
    }
    
    private func rejectPost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.rejectPost(postId: postId) { success in
            if success {
                postViewModel.fetchUnapprovedPosts()
            }
        }
    }
}
