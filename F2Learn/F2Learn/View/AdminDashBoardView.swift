import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminDashboardViewModel
    @State private var isShowingUserList = false
    @State private var isShowingQuickActions = false // Toggle for showing quick actions

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    statsSection // Tapping on this will show the quick actions
                    if isShowingQuickActions { // Show quick actions when tapped
                        quickActionsSection
                    }
                    recentActivitiesSection
                }
                .padding()
            }
            .navigationTitle("Welcome, \(viewModel.adminName)") // Replace "Admin Dashboard" with username
            .navigationBarItems(trailing: logoutButton) // Show logout icon
            .background(
                NavigationLink(
                    destination: UserListView(viewModel: viewModel),
                    isActive: $isShowingUserList,
                    label: { EmptyView() }
                )
            )
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Background color
        }
    }
    
    private var statsSection: some View {
        Button(action: {
            withAnimation {
                isShowingQuickActions.toggle() // Toggle quick actions
            }
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.gray)
                    Text("Common Statistics") // Changed text
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.leading)
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.stats) { stat in
                        StatCard(stat: stat)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var quickActionsSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Actions")
                        .font(.headline)
                        .foregroundColor(.primary)


                // Colorful Quick Action Cards (Manage Users, Moderate Post, View Reports, App Settings)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    QuickActionCard(title: "Manage Users", icon: "person.2.fill", backgroundColor: Color.blue)
                    QuickActionCard(title: "Moderate Posts", icon: "doc.text.fill", backgroundColor: Color.orange)
                    QuickActionCard(title: "View Reports", icon: "chart.pie.fill", backgroundColor: Color.green)
                    QuickActionCard(title: "App Settings", icon: "gearshape.fill", backgroundColor: Color.red)
                }
            }
        }
    
    private var recentActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activities")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading)
            
            ForEach(viewModel.recentActivities) { activity in
                ActivityRow(activity: activity)
            }
            .padding(.horizontal)
        }
    }
    
    // Logout Button as an Icon
    private var logoutButton: some View {
        Button(action: viewModel.logout) {
            Image(systemName: "rectangle.portrait.and.arrow.right") // Logout icon
                .foregroundColor(.red)
                .imageScale(.large)
        }
    }
}
struct QuickActionCard: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// StatCard View for Displaying Stats
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
                .foregroundColor(.primary)
            if let change = stat.change {
                Text(change)
                    .font(.caption)
                    .foregroundColor(change.hasPrefix("+") ? .green : .red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2) // Adds subtle shadow to the cards
    }
}

// QuickActionButton View for Displaying Quick Actions
struct QuickActionButton: View {
    let action: QuickAction
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(systemName: action.icon)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Text(action.title)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

// ActivityRow View for Displaying Recent Activities
struct ActivityRow: View {
    let activity: RecentActivity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.2))
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView(viewModel: AdminDashboardViewModel(authViewModel: AuthViewModel()))
    }
}
