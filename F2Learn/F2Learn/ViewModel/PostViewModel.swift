import Foundation
import Firebase

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var unapprovedPosts: [Post] = []
    private var db = Firestore.firestore()
    
    func createPost(title: String, content: String, authorId: String, authorName: String, tags: [String], imageURL: String?, subjectCategory: SubjectCategory, isAdminPost: Bool, completion: @escaping (Bool) -> Void) {
        let newPost = Post(
            title: title,
            content: content,
            authorId: authorId,
            authorName: authorName,
            createdAt: Date(),
            updatedAt: Date(),
            likes: 0,
            comments: [],
            tags: tags,
            imageURL: imageURL,
            isAdminPost: isAdminPost,
            isApproved: isAdminPost, // Admin posts are automatically approved
            subjectCategory: subjectCategory
        )
        
        do {
            try db.collection("posts").addDocument(from: newPost) { error in
                if let error = error {
                    print("Error adding post: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("Error encoding post: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchPosts(isAdmin: Bool) {
        let query = db.collection("posts")
            .order(by: "createdAt", descending: true)
        
        if !isAdmin {
            query.whereField("isApproved", isEqualTo: true)
        }
        
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.posts = documents.compactMap { queryDocumentSnapshot -> Post? in
                return try? queryDocumentSnapshot.data(as: Post.self)
            }
        }
    }
    
    func approvePost(postId: String, completion: @escaping (Bool) -> Void) {
        db.collection("posts").document(postId).updateData(["isApproved": true]) { error in
            if let error = error {
                print("Error approving post: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchUnapprovedPosts() {
        db.collection("posts")
            .whereField("isApproved", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching unapproved posts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.unapprovedPosts = documents.compactMap { queryDocumentSnapshot -> Post? in
                    return try? queryDocumentSnapshot.data(as: Post.self)
                }
            }
    }
}
