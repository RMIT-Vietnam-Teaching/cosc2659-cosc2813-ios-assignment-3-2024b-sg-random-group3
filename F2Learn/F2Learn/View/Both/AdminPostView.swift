import SwiftUI

struct AdminPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(postViewModel.posts.filter { $0.isAdminPost }) { post in
                    VStack(spacing: 0) {
                        AdminPostCard(post: post, postViewModel: postViewModel)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.customBackground)
                            .onTapGesture {
                                selectedPost = post
                                showingPostDetail = true
                            }
                        
                        Divider()
                            .background(Color.customSecondary.opacity(0.5))
                    }
                }
            }
        }
        .background(Color.customBackground)
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
                        .foregroundColor(.customTextPrimary)
                    Text(post.createdAt, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.customTextSecondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.customPrimary)
            }
            
            Text(post.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.customTextPrimary)
            
            Text(post.content)
                .lineLimit(3)
                .font(.body)
                .foregroundColor(.customTextPrimary)
            
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
                        .fill(Color.customSecondary.opacity(0.3))
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
                
                Spacer()
                
                Label("\(post.comments.count)", systemImage: "bubble.right")
                    .foregroundColor(.customTextSecondary)
                
                Spacer()
                
                Text(post.subjectCategory.rawValue)
                    .font(.caption)
                    .padding(6)
                    .background(Color.customPrimary.opacity(0.1))
                    .foregroundColor(.customPrimary)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.customBackground)
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
                            .foregroundColor(.customTextPrimary)
                        Text(post.createdAt, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.customTextSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.customPrimary)
                }
                
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.customTextPrimary)
                
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.customTextPrimary)
                
                if let imageURL = post.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.customSecondary.opacity(0.3))
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
                    
                    Spacer()
                    
                    Label("\(post.comments.count)", systemImage: "bubble.right")
                        .foregroundColor(.customTextSecondary)
                    
                    Spacer()
                    
                    Text(post.subjectCategory.rawValue)
                        .font(.caption)
                        .padding(6)
                        .background(Color.customPrimary.opacity(0.1))
                        .foregroundColor(.customPrimary)
                        .cornerRadius(12)
                }
                
                Divider()
                    .background(Color.customSecondary)
                
                Text("Comments")
                    .font(.headline)
                    .foregroundColor(.customTextPrimary)
                
                ForEach(post.comments) { comment in
                    CommentView(comment: comment)
                }
                
                HStack {
                    TextField("Add a comment", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.customTextPrimary)
                    Button("Post") {
                        addComment()
                    }
                    .foregroundColor(.customPrimary)
                }
            }
            .padding()
        }
        .background(Color.customBackground)
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
                    .foregroundColor(.customSecondary)
                
                Text(comment.authorName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.customTextPrimary)
                
                Spacer()
                
                Text(comment.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.customTextSecondary)
            }
            
            Text(comment.content)
                .font(.body)
                .foregroundColor(.customTextPrimary)
        }
        .padding()
        .background(Color.customSecondary.opacity(0.1))
        .cornerRadius(8)
    }
}
