import Foundation
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signUp(fullname: String, email: String, phone: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error creating user in Firebase Auth: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let userId = authResult?.user.uid else {
                print("Failed to get user ID after creating user")
                completion(false, "Failed to get user ID")
                return
            }
            
            print("User created successfully in Firebase Auth with ID: \(userId)")
            
            let now = Date()
            let newUser = User(id: userId, fullname: fullname, email: email, phone: phone, role: .user, createdDate: now, lastActive: now)
            self?.saveUserToFirestore(user: newUser) { success in
                if success {
                    print("User data saved successfully to Firestore")
                    self?.currentUser = newUser
                    self?.isAuthenticated = true
                    completion(true, nil)
                } else {
                    print("Failed to save user data to Firestore")
                    completion(false, "Failed to save user data")
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(false, "Failed to get user ID")
                return
            }
            
            self?.fetchUser(userId: userId) { success in
                if success {
                    self?.isAuthenticated = true
                    self?.updateLastActive(userId: userId)
                    completion(true, nil)
                } else {
                    completion(false, "Failed to fetch user data")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func saveUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(user.id).setData([
            "fullname": user.fullname,
            "email": user.email,
            "phone": user.phone,
            "role": user.role.rawValue,
            "createdDate": Timestamp(date: user.createdDate),
            "lastActive": Timestamp(date: user.lastActive)
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User data saved successfully to Firestore")
                completion(true)
            }
        }
    }
    
    private func fetchUser(userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists,
               let data = document.data(),
               let fullname = data["fullname"] as? String,
               let email = data["email"] as? String,
               let phone = data["phone"] as? String,
               let roleString = data["role"] as? String,
               let role = User.UserRole(rawValue: roleString),
               let createdDate = (data["createdDate"] as? Timestamp)?.dateValue(),
               let lastActive = (data["lastActive"] as? Timestamp)?.dateValue() {
                let user = User(id: userId, fullname: fullname, email: email, phone: phone, role: role, createdDate: createdDate, lastActive: lastActive)
                self?.currentUser = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func updateLastActive(userId: String) {
        let now = Date()
        db.collection("users").document(userId).updateData([
            "lastActive": Timestamp(date: now)
        ]) { error in
            if let error = error {
                print("Error updating last active: \(error.localizedDescription)")
            } else {
                self.currentUser?.lastActive = now
            }
        }
    }
}
