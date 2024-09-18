//User model
import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    var phone: String
    var avatar: String?
    var role: UserRole
    var createdDate: Date
    var lastActive: Date
    
    enum UserRole: String, Codable {
        case user
        case admin
    }
}

