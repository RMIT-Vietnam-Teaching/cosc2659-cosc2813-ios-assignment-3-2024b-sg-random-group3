import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let fullName: String
    var phoneNumber: String?
    var role: UserRole	
    var avatarURL: String?
    var bio: String?
    var createdAt: Date
    var lastLoginAt: Date?
    
    enum UserRole: String, Codable {
        case user
        case admin
    }
    
    enum CodingKeys: String, CodingKey {
        case id, email, fullName, phoneNumber, role, avatarURL, bio, createdAt, lastLoginAt
    }
    
    init(id: String? = nil, email: String, fullName: String, phoneNumber: String? = nil, role: UserRole = .user, avatarURL: String? = nil, bio: String? = nil, createdAt: Date = Date(), lastLoginAt: Date? = nil) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.role = role
        self.avatarURL = avatarURL
        self.bio = bio
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}
