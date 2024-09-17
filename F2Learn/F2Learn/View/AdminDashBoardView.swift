import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    @State private var showUserListView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    welcomeSection
                    statsSection
                    quickActionsSection
                    recentActivitiesSection
                }
                .padding()
                .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from assets
            }
            .navigationTitle("Admin Dashboard")
            .navigationBarItems(trailing: logoutButton)
        }
    }
    
    // Welcome Section
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome, \(viewModel.adminName)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("primarycolor")) // Primary color from assets
            Text("Here's an overview of your app")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(Color("secondarycolor")) // Secondary color from assets
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.stats) { stat in
                    StatCard(stat: stat)
                }
            }
        }
    }
    
    // Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(viewModel.quickActions) { action in
                    if action.title == "Manage Users" {
                        QuickActionButton(action: action, onTap: {
                            showUserListView = true
                        })
                    } else {
                        QuickActionButton(action: action, onTap: {
                            print("Tapped on \(action.title)")
                        })
                    }
                }
            }
        }
        .sheet(isPresented: $showUserListView) {
            UserListView(viewModel: viewModel)
        }
    }
    
    // Recent Activities Section
    private var recentActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activities")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(viewModel.recentActivities) { activity in
                ActivityRow(activity: activity)
            }
        }
    }
    
    // Logout Button
    private var logoutButton: some View {
        Button(action: viewModel.logout) {
            Text("Logout")
                .foregroundColor(Color("secondarycolor")) // Secondary color for logout button
        }
    }
}

// Stat Card Component
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
                .foregroundColor(Color("primarycolor")) // Primary color for stats
            if let change = stat.change {
                Text(change)
                    .font(.caption)
                    .foregroundColor(change.hasPrefix("+") ? .green : .red)
            }
        }
        .padding()
        .background(Color.white) // White background for stat cards
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Quick Action Button Component
struct QuickActionButton: View {
    let action: QuickAction
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(systemName: action.icon)
                    .font(.largeTitle)
                    .foregroundColor(Color("primarycolor")) // Primary color for icon
                Text(action.title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white) // White background for buttons
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

// Activity Row Component
struct ActivityRow: View {
    let activity: RecentActivity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(Color("secondarycolor")) // Secondary color for activity icons
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
