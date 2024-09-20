import Foundation

struct Stat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let change: String?
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
 
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
