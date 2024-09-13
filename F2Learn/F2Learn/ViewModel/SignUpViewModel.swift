import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    private var db = Firestore.firestore()
    
    func signUp(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showingAlert = true
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                completion(false)
            } else if let userId = authResult?.user.uid {
                let newUser = User(
                    id: userId,
                    email: self.email,
                    fullName: self.fullName,
                    phoneNumber: self.phoneNumber.isEmpty ? nil : self.phoneNumber,
                    createdAt: Date()
                )
                self.saveUserToFirestore(user: newUser) { success in
                    if success {
                        self.alertMessage = "Account created successfully!"
                        self.showingAlert = true
                        completion(true)
                    } else {
                        self.alertMessage = "Failed to save user data"
                        self.showingAlert = true
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func saveUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("users").document(user.id!).setData(from: user) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch let error {
            print("Error encoding user: \(error.localizedDescription)")
            completion(false)
        }
    }
}
