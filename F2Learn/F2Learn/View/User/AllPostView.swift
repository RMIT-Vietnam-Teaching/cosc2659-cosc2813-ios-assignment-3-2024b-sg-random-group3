import SwiftUI

struct AllPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    
    var body: some View {
        NavigationView {
            List(postViewModel.posts.filter { !$0.isAdminPost && $0.isApproved }) { post in
                PostRow(post: post, postViewModel: postViewModel)
                    .onTapGesture {
                        selectedPost = post
                        showingPostDetail = true
                    }
            }
            .navigationTitle("All Posts")
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
}

struct PostRow: View {
    let post: Post
    @ObservedObject var postViewModel: PostViewModel
    @State private var authorAvatarURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                .font(.title3)
                .fontWeight(.bold)
            Text(post.content)
                .font(.body)
                .lineLimit(3)
            
            HStack {
                Label("\(post.likes)", systemImage: "heart")
                Label("\(post.comments.count)", systemImage: "bubble.left")
                Spacer()
                Text(post.subjectCategory.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.blue.opacity(0.1))
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
}

struct PostDetailView: View {
    let post: Post
    @ObservedObject var postViewModel: PostViewModel
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
                        // Implement like functionality
                    }) {
                        Label("\(post.likes)", systemImage: "heart")
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
                        // Implement add comment functionality
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
