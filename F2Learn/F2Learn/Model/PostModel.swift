import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var authorId: String
    var authorName: String
    var createdAt: Date
    var updatedAt: Date
    var likes: Int
    var comments: [Comment]
    var tags: [String]
    var imageURL: String?
    var isAdminPost: Bool
    var isApproved: Bool
    var subjectCategory: SubjectCategory
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, authorId, authorName, createdAt, updatedAt, likes, comments, tags, imageURL, isAdminPost, isApproved, subjectCategory
    }
}

struct Comment: Identifiable, Codable {
    var id: String
    var authorId: String
    var authorName: String
    var content: String
    var createdAt: Date
}

enum SubjectCategory: String, Codable, CaseIterable {
    case mathematics = "Mathematics"
    case science = "Science"
    case literature = "Literature"
    case history = "History"
    case geography = "Geography"
    case english = "English"
    case foreignLanguages = "Foreign Languages"
    case artAndMusic = "Art and Music"
    case physicalEducation = "Physical Education"
    case computerScience = "Computer Science"
    case socialStudies = "Social Studies"
}
