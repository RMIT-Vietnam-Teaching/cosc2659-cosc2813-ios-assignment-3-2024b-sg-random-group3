import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var postViewModel: PostViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingLogoutAlert = false
    @State private var postCount = 0
    @State private var likeCount = 0
    @State private var commentCount = 0
    
    init(postViewModel: PostViewModel) {
        self.postViewModel = postViewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                profileHeader
                userInfoSection
                statsSection
                logoutButton
            }
            .padding()
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Profile")
        .navigationBarItems(trailing: closeButton)
        .onAppear {
            fetchUserStats()
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    authViewModel.signOut()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            if let avatarURL = authViewModel.currentUser?.avatar, let url = URL(string: avatarURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.customPrimary, lineWidth: 3))
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.customPrimary)
            }
            
            Text(authViewModel.currentUser?.fullname ?? "")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var userInfoSection: some View {
        VStack(spacing: 15) {
            infoRow(icon: "envelope", title: "Email", value: authViewModel.currentUser?.email ?? "")
            infoRow(icon: "phone", title: "Phone", value: authViewModel.currentUser?.phone ?? "")
            infoRow(icon: "calendar", title: "Joined", value: formattedDate(authViewModel.currentUser?.createdDate))
            infoRow(icon: "clock", title: "Last Active", value: formattedDate(authViewModel.currentUser?.lastActive))
        }
        .padding()
        .background(Color.customSecondary.opacity(0.1))
        .cornerRadius(15)
    }
    
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.customPrimary)
                .frame(width: 30)
            Text(title)
                .foregroundColor(.customTextSecondary)
            Spacer()
            Text(value)
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var statsSection: some View {
        HStack {
            statItem(title: "Posts", value: "\(postCount)")
            statItem(title: "Likes", value: "\(likeCount)")
            statItem(title: "Comments", value: "\(commentCount)")
        }
        .padding()
        .background(Color.customSecondary.opacity(0.1))
        .cornerRadius(15)
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.customPrimary)
            Text(title)
                .font(.caption)
                .foregroundColor(.customTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var logoutButton: some View {
        Button(action: {
            showingLogoutAlert = true
        }) {
            Text("Logout")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.customPrimary)
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func fetchUserStats() {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        // Fetch post count
        postViewModel.fetchUserPostCount(userId: userId) { count in
            self.postCount = count
        }
        
        // Fetch like count
        postViewModel.fetchUserLikeCount(userId: userId) { count in
            self.likeCount = count
        }
        
        // Fetch comment count
        postViewModel.fetchUserCommentCount(userId: userId) { count in
            self.commentCount = count
        }
    }
}
