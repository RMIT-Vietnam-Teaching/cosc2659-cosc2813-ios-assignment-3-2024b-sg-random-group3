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

struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    @State private var isShowingUserList = false
    @State private var isShowingCreatePost = false
    @State private var isShowingUnapprovedPosts = false


    var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        welcomeSection
                        statsSection
                        quickActionsSection
                        recentActivitiesSection
                    }
                    .padding()
                }
                .navigationTitle("Admin Dashboard")
                .navigationBarItems(trailing: logoutButton)
                .background(
                    NavigationLink(destination: UserListView(viewModel: viewModel), isActive: $isShowingUserList) {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(destination: CreatePostView(postViewModel: viewModel.postViewModel), isActive: $isShowingCreatePost) {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(destination: UnapprovedPostsView(postViewModel: viewModel.postViewModel), isActive: $isShowingUnapprovedPosts) {
                        EmptyView()
                    }
                )
            }
        }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading) {
            Text("Welcome, \(viewModel.adminName)")
                .font(.title)
                .fontWeight(.bold)
            Text("Here's an overview of your app")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.stats) { stat in
                StatCard(stat: stat)
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(viewModel.quickActions) { action in
                    QuickActionButton(action: action) {
                        switch action.title {
                        case "Manage Users":
                            isShowingUserList = true
                        case "Create Post":
                            isShowingCreatePost = true
                        case "Moderate Posts":
                            isShowingUnapprovedPosts = true
                        default:
                            print("Tapped on \(action.title)")
                        }
                    }
                }
            }
        }
    }
    private var recentActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activities")
                .font(.headline)
            
            ForEach(viewModel.recentActivities) { activity in
                ActivityRow(activity: activity)
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: viewModel.logout) {
            Text("Logout")
        }
    }
}

struct StatCard: View {
    let stat: Stat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.title2)
                .fontWeight(.bold)
            if let change = stat.change {
                Text(change)
                    .font(.caption)
                    .foregroundColor(change.hasPrefix("+") ? .green : .red)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct QuickActionButton: View {
    let action: QuickAction
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(systemName: action.icon)
                    .font(.largeTitle)
                Text(action.title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(10)
        }
    }
}

struct ActivityRow: View {
    let activity: RecentActivity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(activity.time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}
