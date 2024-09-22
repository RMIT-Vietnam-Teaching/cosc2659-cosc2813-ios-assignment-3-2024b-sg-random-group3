/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Random Group 3/F2 Learn
  ID: Tran Ngoc Minh – s3911737
      Nguyen Duong Truong Thinh – s3914412
      Dang Minh Triet – s4022878
      Du Tuan Vu – s3924489
  Created  date:  26/08/2024
  Last modified:  23/09/2024
  Acknowledgement: RMIT Canvas( tutorials, modules)
*/

import SwiftUI

struct UserPostsView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    @State private var postToDelete: Post?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(postViewModel.posts.filter { $0.authorId == authViewModel.currentUser?.id }) { post in
                        UserPostCard(post: post)
                            .onTapGesture {
                                selectedPost = post
                                showingPostDetail = true
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("My Posts")
        .onAppear {
            postViewModel.fetchPosts(isAdmin: false)
        }
        .sheet(isPresented: $showingPostDetail) {
            if let post = selectedPost {
                UserPostDetailView(post: post, postViewModel: postViewModel, showingEditView: $showingEditView, showingDeleteConfirmation: $showingDeleteConfirmation, postToDelete: $postToDelete)
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let post = selectedPost, !post.isApproved {
                EditPostView(post: post, postViewModel: postViewModel)
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Post"),
                message: Text("Are you sure you want to delete this post?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let post = postToDelete {
                        deletePost(post)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func deletePost(_ post: Post) {
        guard let postId = post.id else { return }
        postViewModel.deletePost(postId: postId) { success in
            if success {
                postViewModel.fetchPosts(isAdmin: false)
            }
        }
    }
}

struct UserPostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .foregroundColor(.customTextPrimary)
            Text(post.content)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.customTextSecondary)
            HStack {
                Text(post.subjectCategory.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.customPrimary.opacity(0.1))
                    .foregroundColor(.customPrimary)
                    .cornerRadius(4)
                Spacer()
                Text(post.isApproved ? "Approved" : "Pending")
                    .font(.caption)
                    .foregroundColor(post.isApproved ? .green : .orange)
            }
        }
        .padding()
        .background(Color.customBackground)
        .cornerRadius(10)
        .shadow(color: Color.customSecondary.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct UserPostDetailView: View {
    let post: Post
    @ObservedObject var postViewModel: PostViewModel
    @Binding var showingEditView: Bool
    @Binding var showingDeleteConfirmation: Bool
    @Binding var postToDelete: Post?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.customTextPrimary)
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.customTextPrimary)
                HStack {
                    Text(post.subjectCategory.rawValue)
                        .font(.caption)
                        .padding(6)
                        .background(Color.customPrimary.opacity(0.1))
                        .foregroundColor(.customPrimary)
                        .cornerRadius(8)
                    Spacer()
                    Text(post.isApproved ? "Approved" : "Pending")
                        .font(.caption)
                        .foregroundColor(post.isApproved ? .green : .orange)
                }
                
                if !post.isApproved {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button("Delete") {
                    postToDelete = post
                    showingDeleteConfirmation = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Post Details")
    }
}

struct EditPostView: View {
    @State var post: Post
    @ObservedObject var postViewModel: PostViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $post.title)
                    TextEditor(text: $post.content)
                        .frame(height: 200)
                }
                
                Section(header: Text("Category")) {
                    Picker("Subject Category", selection: $post.subjectCategory) {
                        ForEach(SubjectCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section {
                    Button("Save Changes") {
                        updatePost()
                    }
                }
            }
            .navigationTitle("Edit Post")
        }
    }
    
    private func updatePost() {
        postViewModel.updatePost(post: post) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
