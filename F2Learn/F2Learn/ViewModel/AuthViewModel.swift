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
                completion(false, error.localizedDescription)
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(false, "Failed to get user ID")
                return
            }
            
            let newUser = User(id: userId, fullname: fullname, email: email, phone: phone, role: .user)
            self?.saveUserToFirestore(user: newUser) { success in
                if success {
                    self?.currentUser = newUser
                    self?.isAuthenticated = true
                    completion(true, nil)
                } else {
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
            "role": user.role.rawValue
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                completion(false)
            } else {
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
               let role = User.UserRole(rawValue: roleString) {
                let user = User(id: userId, fullname: fullname, email: email, phone: phone, role: role)
                self?.currentUser = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
