import SwiftUI

struct AllPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("All Posts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.customBackground)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(postViewModel.posts.filter { !$0.isAdminPost && $0.isApproved }) { post in
                        VStack(spacing: 0) {
                            PostRow(post: post, postViewModel: postViewModel)
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
        }
        .onAppear {
            postViewModel.fetchPosts(isAdmin: false)
        }
        .sheet(isPresented: $showingPostDetail) {
            if let post = selectedPost {
                PostDetailView(post: post, postViewModel: postViewModel)
            }
        }
    }
}

struct PostRow: View {
    let post: Post
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var authorAvatarURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                UserAvatar(url: authorAvatarURL)
                VStack(alignment: .leading) {
                    Text(post.authorName)
                        .font(.headline)
                        .foregroundColor(.customTextPrimary)
                    Text(post.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.customTextSecondary)
                }
            }
            
            Text(post.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.customTextPrimary)
            Text(post.content)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.customTextPrimary)
            
            HStack {
                Button(action: {
                    likePost()
                }) {
                    Label("\(post.likes)", systemImage: post.likedBy.contains(authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                Label("\(post.comments.count)", systemImage: "bubble.left")
                    .foregroundColor(.customTextSecondary)
                Spacer()
                Text(post.subjectCategory.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.customPrimary.opacity(0.1))
                    .foregroundColor(.customPrimary)
                    .cornerRadius(4)
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
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

struct PostDetailView: View {
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
                            .font(.caption)
                    }
                }
                
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(post.content)
                    .font(.body)
                
                HStack {
                    Button(action: {
                        likePost()
                    }) {
                        Label("\(post.likes)", systemImage: post.likedBy.contains(authViewModel.currentUser?.id ?? "") ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text(post.subjectCategory.rawValue)
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Divider()
                
                Text("Comments")
                    .font(.headline)
                
                ForEach(post.comments) { comment in
                    CommentRow(comment: comment, postViewModel: postViewModel)
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

struct CommentRow: View {
    let comment: Comment
    @ObservedObject var postViewModel: PostViewModel
    @State private var authorAvatarURL: String?
    
    var body: some View {
        HStack(alignment: .top) {
            UserAvatar(url: authorAvatarURL)
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.authorName)
                    .font(.headline)
                Text(comment.content)
                    .font(.body)
                Text(comment.createdAt, style: .date)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            postViewModel.getUserAvatar(for: comment.authorId) { avatarURL in
                self.authorAvatarURL = avatarURL
            }
        }
    }
}

struct UserAvatar: View {
    let url: String?
    
    var body: some View {
        if let url = url, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
    }
}
