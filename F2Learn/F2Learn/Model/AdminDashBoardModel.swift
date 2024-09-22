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
