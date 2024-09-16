import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        statsGridView
                        quickActionsView
                        recentActivityView
                    }
                    .padding()
                }
            }
            .navigationTitle("Admin Dashboard")
            .navigationBarItems(trailing: profileButton)
        }
        .accentColor(.purple)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome back, \(viewModel.adminName)")
                .font(.title)
                .fontWeight(.bold)
            Text("Here's what's happening today")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private var statsGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.stats) { stat in
                StatCardView(stat: stat)
            }
        }
    }
    
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 20) {
                ForEach(viewModel.quickActions) { action in
                    QuickActionButton(action: action)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private var recentActivityView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity")
                .font(.headline)
            
            ForEach(viewModel.recentActivities) { activity in
                ActivityRow(activity: activity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private var profileButton: some View {
        Button(action: viewModel.showProfile) {
            Image(systemName: "person.circle")
                .imageScale(.large)
        }
    }
}

struct StatCardView: View {
    let stat: Stat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(stat.title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.title)
                .fontWeight(.bold)
            Text(stat.change)
                .font(.caption)
                .foregroundColor(stat.change.contains("+") ? .green : .red)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct QuickActionButton: View {
    let action: QuickAction
    
    var body: some View {
        Button(action: {}) {
            VStack {
                Image(systemName: action.icon)
                    .font(.largeTitle)
                Text(action.title)
                    .font(.caption)
            }
            .foregroundColor(.purple)
            .frame(width: 80, height: 80)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(15)
        }
    }
}

struct ActivityRow: View {
    let activity: RecentActivity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(.purple)
                .frame(width: 30, height: 30)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
            
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
