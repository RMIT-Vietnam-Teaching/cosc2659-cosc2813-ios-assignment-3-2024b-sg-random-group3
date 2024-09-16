import SwiftUI
import Firebase
import Combine

class AdminDashboardViewModel: ObservableObject {
    @Published var stats: [Stat] = []
    @Published var quickActions: [QuickAction] = []
    @Published var recentActivities: [RecentActivity] = []
    
    private var db = Firestore.firestore()
    private var cancellables: Set<AnyCancellable> = []
    
    // Reference to the AuthViewModel to access current user data
    @Published var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        fetchStats()
        setupQuickActions()
        fetchRecentActivities()
    }
    
    var adminName: String {
        authViewModel.currentUser?.fullname ?? "Admin"
    }
    
    func fetchStats() {
        db.collection("stats").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching stats: \(error.localizedDescription)")
                return
            }
            
            let fetchedStats = snapshot?.documents.compactMap { document -> Stat? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let value = data["value"] as? String,
                      let change = data["change"] as? String else {
                    return nil
                }
                return Stat(title: title, value: value, change: change)
            } ?? []
            
            DispatchQueue.main.async {
                self?.stats = fetchedStats
            }
        }
    }
    
    func setupQuickActions() {
        quickActions = [
            QuickAction(title: "Users", icon: "person.2"),
            QuickAction(title: "Posts", icon: "doc.text"),
            QuickAction(title: "Reports", icon: "flag"),
            QuickAction(title: "Settings", icon: "gear")
        ]
    }
    
    func fetchRecentActivities() {
        db.collection("activities")
            .order(by: "timestamp", descending: true)
            .limit(to: 5)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching recent activities: \(error.localizedDescription)")
                    return
                }
                
                let fetchedActivities = snapshot?.documents.compactMap { document -> RecentActivity? in
                    let data = document.data()
                    guard let icon = data["icon"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    let timeAgo = timestamp.dateValue().timeAgoDisplay()
                    return RecentActivity(icon: icon, title: title, description: description, time: timeAgo)
                } ?? []
                
                DispatchQueue.main.async {
                    self?.recentActivities = fetchedActivities
                }
            }
    }
    
    func showProfile() {
        // Handle showing admin profile
        print("Show admin profile")
    }
}

// Helper extension for date formatting
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}


struct Stat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let change: String
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

struct RecentActivity: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let time: String
}
