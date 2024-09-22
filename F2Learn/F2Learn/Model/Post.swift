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
    var likedBy: [String]
    var comments: [Comment]
    var tags: [String]
    var imageURL: String?
    var isAdminPost: Bool
    var isApproved: Bool
    var isRejected: Bool = false
    var subjectCategory: SubjectCategory
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, authorId, authorName, createdAt, updatedAt, likes, likedBy, comments, tags, imageURL, isAdminPost, isApproved, subjectCategory
        case isRejected
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
