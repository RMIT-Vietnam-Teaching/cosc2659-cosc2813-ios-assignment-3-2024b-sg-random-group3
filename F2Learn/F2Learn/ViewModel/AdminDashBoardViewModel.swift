import SwiftUI
import Firebase
import FirebaseFirestore


class AdminDashboardViewModel: ObservableObject {
    @Published var stats: [Stat] = []
    @Published var quickActions: [QuickAction] = []
    @Published var recentActivities: [RecentActivity] = []
    @Published var users: [User] = []
    
    private var db = Firestore.firestore()
    var authViewModel: AuthViewModel
    
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
        fetchTotalUsers()
        fetchTotalPosts()
        fetchActiveUsers()
    }
    
    private func fetchTotalUsers() {
        db.collection("users").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            let totalUsers = snapshot?.documents.count ?? 0
            DispatchQueue.main.async {
                self?.stats.append(Stat(title: "Total Users", value: "\(totalUsers)", change: nil))
            }
        }
    }
    
    private func fetchTotalPosts() {
        db.collection("posts").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            let totalPosts = snapshot?.documents.count ?? 0
            DispatchQueue.main.async {
                self?.stats.append(Stat(title: "Total Posts", value: "\(totalPosts)", change: nil))
            }
        }
    }
    
    private func fetchActiveUsers() {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        db.collection("users")
            .whereField("lastActive", isGreaterThan: sevenDaysAgo)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching active users: \(error.localizedDescription)")
                    return
                }
                
                let activeUsers = snapshot?.documents.count ?? 0
                DispatchQueue.main.async {
                    self?.stats.append(Stat(title: "Active Users (7 days)", value: "\(activeUsers)", change: nil))
                }
            }
    }
    
    func setupQuickActions() {
        quickActions = [
            QuickAction(title: "Manage Users", icon: "person.2"),
            QuickAction(title: "Moderate Posts", icon: "doc.text"),
            QuickAction(title: "View Reports", icon: "flag"),
            QuickAction(title: "App Settings", icon: "gear")
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
    
    func logout() {
        authViewModel.signOut()
    }
    
    func fetchAllUsers() {
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            self?.users = querySnapshot?.documents.compactMap { document -> User? in
                let data = document.data()
                guard let id = document.documentID as String?,
                      let fullname = data["fullname"] as? String,
                      let email = data["email"] as? String,
                      let phone = data["phone"] as? String,
                      let roleString = data["role"] as? String,
                      let role = User.UserRole(rawValue: roleString),
                      let createdDate = (data["createdDate"] as? Timestamp)?.dateValue(),
                      let lastActive = (data["lastActive"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                return User(id: id, fullname: fullname, email: email, phone: phone, role: role, createdDate: createdDate, lastActive: lastActive)
            } ?? []
            
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }
    
    func updateUser(user: User, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(user.id).updateData([
            "fullname": user.fullname,
            "email": user.email,
            "phone": user.phone
        ]) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                completion(false)
            } else {
                self.fetchAllUsers()
                completion(true)
            }
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
                completion(false)
            } else {
                self.fetchAllUsers()
                completion(true)
            }
        }
    }
}
