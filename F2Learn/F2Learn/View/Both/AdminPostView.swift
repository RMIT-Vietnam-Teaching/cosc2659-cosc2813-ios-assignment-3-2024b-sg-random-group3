import SwiftUI

struct AdminPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State private var selectedPost: Post?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(postViewModel.posts.filter { $0.isAdminPost }) { post in
                    AdminPostCard(post: post)
                        .onTapGesture {
                            selectedPost = post
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Admin Posts")
        .onAppear {
            postViewModel.fetchPosts(isAdmin: true)
        }
        .sheet(item: $selectedPost) { post in
            AdminPostDetailView(post: post)
        }
    }
}

struct AdminPostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                
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
                Label("\(post.likes)", systemImage: "heart")
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
    }
}

struct AdminPostDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .foregroundColor(.blue)
                    
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
                    Label("\(post.likes)", systemImage: "heart")
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
            }
            .padding()
        }
        .navigationTitle("Post Details")
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
