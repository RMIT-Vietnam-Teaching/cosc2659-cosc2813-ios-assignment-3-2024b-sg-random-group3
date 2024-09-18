import SwiftUI

struct AllPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            List(postViewModel.posts.filter { !$0.isAdminPost && $0.isApproved }) { post in
                PostRow(post: post)
            }
            .navigationTitle("All Posts")
            .onAppear {
                postViewModel.fetchPosts(isAdmin: false)
            }
        }
    }
}

struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
            Text(post.content)
                .font(.subheadline)
                .lineLimit(2)
            HStack {
                Text("By \(post.authorName)")
                    .font(.caption)
                Spacer()
                Text(post.createdAt, style: .date)
                    .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}
