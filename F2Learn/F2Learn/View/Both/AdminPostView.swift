import SwiftUI

struct AdminPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(postViewModel.posts.filter { $0.isAdminPost }) { post in
                    AdminPostCard(post: post, postViewModel: postViewModel)
                        .onTapGesture {
                            selectedPost = post
                            showingPostDetail = true
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Admin Posts")
        .onAppear {
            postViewModel.fetchPosts(isAdmin: true)
        }
        .sheet(isPresented: $showingPostDetail) {
            if let post = selectedPost {
                AdminPostDetailView(post: post, postViewModel: postViewModel)
            }
        }
    }
}

struct AdminPostCard: View {
    let post: Post
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var authorAvatarURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                UserAvatar(url: authorAvatarURL)
                VStack(alignment: .leading) {
                    Text(post.authorName)
                        .font(.headline)
                    Text(post.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
            }
            
            Text(post.title)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(post.content)
                .lineLimit(3)
                .font(.body)
            
            if let imageURL = post.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(8)
                }
            }
            
            HStack {
                Button(action: {
                    likePost()
                }) {
                    Label("\(post.likes)", systemImage: post.likedBy.contains(authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Label("\(post.comments.count)", systemImage: "bubble.right")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(post.subjectCategory.rawValue)
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            postViewModel.getUserAvatar(for: post.authorId) { avatarURL in
                self.authorAvatarURL = avatarURL
            }
        }
    }
    
    private func likePost() {
        guard let userId = authViewModel.currentUser?.id, let postId = post.id else { return }
        postViewModel.likePost(postId: postId, userId: userId) { success in
            if success {
                // The post is already updated in the list by the ViewModel
            }
        }
    }
}

struct AdminPostDetailView: View {
    @State var post: Post
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newComment = ""
    @State private var authorAvatarURL: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    UserAvatar(url: authorAvatarURL)
                    VStack(alignment: .leading) {
                        Text(post.authorName)
                            .font(.headline)
                        Text(post.createdAt, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.blue)
                }
                
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(post.content)
                    .font(.body)
                
                if let imageURL = post.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(8)
                    }
                }
                
                HStack {
                    Button(action: {
                        likePost()
                    }) {
                        Label("\(post.likes)", systemImage: post.likedBy.contains(authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label("\(post.comments.count)", systemImage: "bubble.right")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(post.subjectCategory.rawValue)
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                }
                
                Divider()
                
                Text("Comments")
                    .font(.headline)
                
                ForEach(post.comments) { comment in
                    CommentView(comment: comment)
                }
                
                HStack {
                    TextField("Add a comment", text: $newComment)
                    Button("Post") {
                        addComment()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Post Details")
        .onAppear {
            postViewModel.getUserAvatar(for: post.authorId) { avatarURL in
                self.authorAvatarURL = avatarURL
            }
        }
    }
    
    private func likePost() {
        guard let userId = authViewModel.currentUser?.id, let postId = post.id else { return }
        postViewModel.likePost(postId: postId, userId: userId) { success in
            if success {
                if let updatedPost = postViewModel.posts.first(where: { $0.id == post.id }) {
                    post = updatedPost
                }
            }
        }
    }
    
    private func addComment() {
        guard let userId = authViewModel.currentUser?.id,
              let userName = authViewModel.currentUser?.fullname,
              let postId = post.id,
              !newComment.isEmpty else { return }
        
        let comment = Comment(id: UUID().uuidString,
                              authorId: userId,
                              authorName: userName,
                              content: newComment,
                              createdAt: Date())
        
        postViewModel.addComment(to: postId, comment: comment) { success in
            if success {
                if let updatedPost = postViewModel.posts.first(where: { $0.id == post.id }) {
                    post = updatedPost
                }
                newComment = ""
            }
        }
    }
}

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                
                Text(comment.authorName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(comment.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(comment.content)
                .font(.body)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
