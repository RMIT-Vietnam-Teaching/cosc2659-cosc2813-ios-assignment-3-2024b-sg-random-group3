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


import SwiftUI
import Firebase

class UserDashboardViewModel: ObservableObject {
    @Published var adminPosts: [Post] = []
    @Published var allPosts: [Post] = []
    @Published var savedPosts: [Post] = []
    @Published var userPosts: [Post] = []
    
    private var db = Firestore.firestore()
    private var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        fetchAdminPosts()
        fetchAllPosts()
        fetchSavedPosts()
        fetchUserPosts()
    }
    
    func fetchAdminPosts() {
        db.collection("posts")
            .whereField("isAdminPost", isEqualTo: true)
            .whereField("isApproved", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching admin posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.adminPosts = documents.compactMap { queryDocumentSnapshot -> Post? in
                    return try? queryDocumentSnapshot.data(as: Post.self)
                }
            }
    }
    
    func fetchAllPosts() {
        db.collection("posts")
            .whereField("isApproved", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching all posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.allPosts = documents.compactMap { queryDocumentSnapshot -> Post? in
                    return try? queryDocumentSnapshot.data(as: Post.self)
                }
            }
    }
    
    func fetchSavedPosts() {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        db.collection("users").document(userId).collection("savedPosts")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching saved posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let savedPostIds = documents.compactMap { $0.documentID }
                
                self.db.collection("posts").whereField(FieldPath.documentID(), in: savedPostIds)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching saved posts: \(error.localizedDescription)")
                            return
                        }
                        
                        self.savedPosts = querySnapshot?.documents.compactMap { queryDocumentSnapshot -> Post? in
                            return try? queryDocumentSnapshot.data(as: Post.self)
                        } ?? []
                    }
            }
    }
    
    func fetchUserPosts() {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        db.collection("posts")
            .whereField("authorId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching user posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.userPosts = documents.compactMap { queryDocumentSnapshot -> Post? in
                    return try? queryDocumentSnapshot.data(as: Post.self)
                }
            }
    }
}
