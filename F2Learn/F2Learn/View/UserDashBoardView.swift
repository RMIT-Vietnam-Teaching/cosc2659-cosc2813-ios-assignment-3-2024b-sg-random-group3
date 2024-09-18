import SwiftUI

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var postViewModel = PostViewModel()
    @State private var showingCreatePost = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                userInfoSection
                
                createPostButton
                
                userPostsList
            }
            .padding()
            .navigationTitle("User Dashboard")
            .navigationBarItems(trailing: logoutButton)
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(postViewModel: postViewModel)
            }
            .onAppear {
                if let user = authViewModel.currentUser {
                    postViewModel.fetchPosts(isAdmin: user.role == .admin)
                }
            }
        }
    }
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome, \(authViewModel.currentUser?.fullname ?? "")")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Email: \(authViewModel.currentUser?.email ?? "")")
            Text("Phone: \(authViewModel.currentUser?.phone ?? "")")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var createPostButton: some View {
        Button(action: {
            showingCreatePost = true
        }) {
            Text("Create New Post")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var userPostsList: some View {
        List {
            ForEach(postViewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.content)
                        .font(.subheadline)
                        .lineLimit(2)
                    Text("Category: \(post.subjectCategory.rawValue)")
                        .font(.caption)
                    Text("Created: \(post.createdAt, formatter: DateFormatter.shortDate)")
                        .font(.caption)
                }
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: authViewModel.signOut) {
            Text("Logout")
        }
    }
}
