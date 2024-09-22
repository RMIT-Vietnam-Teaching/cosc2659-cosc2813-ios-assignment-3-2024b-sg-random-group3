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

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var postViewModel = PostViewModel()
    @State private var selectedTab = 0
    @State private var showingProfile = false
    @State private var showingNotifications = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                AdminPostsView(postViewModel: postViewModel)
                    .tabItem {
                        Label("Admin Post", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ExploreView(postViewModel: postViewModel)
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                CreatePostView(postViewModel: postViewModel)
                    .tabItem {
                        Label("Create", systemImage: "plus.circle.fill")
                    }
                    .tag(2)
                
                UserPostsView(postViewModel: postViewModel)
                    .tabItem {
                        Label("My Posts", systemImage: "person.fill")
                    }
                    .tag(3)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(4)
            }
            .accentColor(.customPrimary)
            .navigationBarTitle(navigationTitle)
            .navigationBarItems(leading: profileButton, trailing: notificationButton)
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView(postViewModel: postViewModel)
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationsView()
        }
    }
    
    var navigationTitle: String {
        switch selectedTab {
        case 0: return "Home"
        case 1: return "Explore"
        case 2: return "Create Post"
        case 3: return "My Posts"
        case 4: return "Settings"
        default: return ""
        }
    }
    
    var profileButton: some View {
            Button(action: { showingProfile = true }) {
                if let avatarURL = authViewModel.currentUser?.avatar,
                   let url = URL(string: avatarURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.customPrimary)
                    }
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.customPrimary)
                }
            }
        }
    
    var notificationButton: some View {
        Button(action: { showingNotifications = true }) {
            Image(systemName: "bell")
                .foregroundColor(.customPrimary)
        }
    }
}


struct WelcomeBanner: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome back,")
                .font(.title2)
            Text(authViewModel.currentUser?.fullname ?? "User")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.customPrimary.opacity(0.1))
        .cornerRadius(15)
    }
}

struct FeaturedPosts: View {
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Featured Posts")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(postViewModel.posts.prefix(5)) { post in
                        FeaturedPostCard(post: post)
                    }
                }
            }
        }
    }
}

struct FeaturedPostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            Text(post.content)
                .font(.subheadline)
                .lineLimit(3)
            Text(post.subjectCategory.rawValue)
                .font(.caption)
                .padding(4)
                .background(Color.customPrimary.opacity(0.1))
                .cornerRadius(4)
        }
        .frame(width: 200, height: 150)
        .padding()
        .background(Color.customBackground)
        .cornerRadius(10)
        .shadow(color: Color.customSecondary.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct NotificationsView: View {
    // Implement notifications view
    var body: some View {
        Text("Notifications")
    }
}
