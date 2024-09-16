//User model
struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    var phone: String
    var avatar: String?
    var role: UserRole
    
    enum UserRole: String, Codable {
        case user
        case admin
    }
}
