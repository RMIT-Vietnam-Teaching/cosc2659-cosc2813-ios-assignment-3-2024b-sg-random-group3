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
            likedBy: [],
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
    func rejectPost(postId: String, completion: @escaping (Bool) -> Void) {
        db.collection("posts").document(postId).delete { error in
            if let error = error {
                print("Error rejecting post: \(error.localizedDescription)")
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
    
    func getUserAvatar(for userId: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let avatarURL = document.data()?["avatar"] as? String
                completion(avatarURL)
            } else {
                completion(nil)
            }
        }
    }
    func likePost(postId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let postRef = db.collection("posts").document(postId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var post = try? postDocument.data(as: Post.self) else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch post data"])
                errorPointer?.pointee = error
                return nil
            }
            
            if post.likedBy.contains(userId) {
                post.likes -= 1
                post.likedBy.removeAll { $0 == userId }
            } else {
                post.likes += 1
                post.likedBy.append(userId)
            }
            
            do {
                try transaction.setData(from: post, forDocument: postRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            return post
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(false)
            } else if let updatedPost = object as? Post {
                self.updatePostInList(updatedPost)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func updatePostInList(_ updatedPost: Post) {
        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
            posts[index] = updatedPost
        }
    }
    
    func addComment(to postId: String, comment: Comment, completion: @escaping (Bool) -> Void) {
        let postRef = db.collection("posts").document(postId)
        
        postRef.updateData([
            "comments": FieldValue.arrayUnion([comment.toDictionary()])
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error)")
                completion(false)
            } else {
                self.refreshPost(postId: postId)
                completion(true)
            }
        }
    }
    
    func refreshPost(postId: String) {
        let postRef = db.collection("posts").document(postId)
        
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let updatedPost = try document.data(as: Post.self)
                    self.updatePostInList(updatedPost)
                } catch {
                    print("Error decoding post: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension Comment {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "authorId": authorId,
            "authorName": authorName,
            "content": content,
            "createdAt": createdAt
        ]
    }
}
