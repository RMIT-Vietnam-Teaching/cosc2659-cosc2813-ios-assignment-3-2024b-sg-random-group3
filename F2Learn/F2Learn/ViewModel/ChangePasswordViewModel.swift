import SwiftUI
import Firebase
import FirebaseAuth

class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var showAlert = false
    
    func changePassword(completion: @escaping (Bool) -> Void) {
        guard validateInputs() else {
            completion(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        guard let user = Auth.auth().currentUser else {
            showError("User not found. Please log in again.")
            completion(false)
            return
        }
        
        // Reauthenticate the user
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
        user.reauthenticate(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showError("Failed to reauthenticate: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Change the password
            user.updatePassword(to: self.newPassword) { error in
                self.isLoading = false
                if let error = error {
                    self.showError("Failed to change password: \(error.localizedDescription)")
                    completion(false)
                } else {
                    self.showSuccess("Password changed successfully!")
                    completion(true)
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        if currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty {
            showError("All fields are required.")
            return false
        }
        
        if newPassword != confirmNewPassword {
            showError("New passwords do not match.")
            return false
        }
        
        if newPassword.count < 6 {
            showError("New password must be at least 6 characters long.")
            return false
        }
        
        return true
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        successMessage = nil
        showAlert = true
        isLoading = false
    }
    
    private func showSuccess(_ message: String) {
        successMessage = message
        errorMessage = nil
        showAlert = true
        isLoading = false
    }
}
