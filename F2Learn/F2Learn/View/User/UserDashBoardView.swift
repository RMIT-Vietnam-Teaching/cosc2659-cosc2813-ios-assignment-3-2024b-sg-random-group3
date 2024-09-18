import SwiftUI

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var postViewModel = PostViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AdminPostsView(postViewModel: postViewModel)
                .tabItem {
                    Label("Admin Posts", systemImage: "star.fill")
                }
                .tag(0)
            
            AllPostsView(postViewModel: postViewModel)
                .tabItem {
                    Label("All Posts", systemImage: "list.bullet")
                }
                .tag(1)
            
            CreatePostView(postViewModel: postViewModel)
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            SavedPostsView(postViewModel: postViewModel)
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                .tag(3)
            
//            UserPostsView(postViewModel: postViewModel)
//                .tabItem {
//                    Label("My Posts", systemImage: "person.fill")
//                }
//                .tag(4)
//            
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
//                .tag(5)
        }
        .accentColor(.blue)
    }
}
