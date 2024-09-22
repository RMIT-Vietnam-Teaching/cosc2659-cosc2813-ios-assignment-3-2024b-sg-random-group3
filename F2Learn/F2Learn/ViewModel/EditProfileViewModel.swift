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
import FirebaseStorage
import FirebaseFirestore

class EditProfileViewModel: ObservableObject {
    @Published var fullname: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var avatar: UIImage?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var avatarURL: URL?
    
    private var authViewModel: AuthViewModel
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        loadUserData()
    }
    
    func loadUserData() {
        guard let currentUser = authViewModel.currentUser else { return }
        fullname = currentUser.fullname
        email = currentUser.email
        phone = currentUser.phone
        
        if let avatarURL = currentUser.avatar {
            loadAvatarImage(from: avatarURL)
        }
    }
    
    private func loadAvatarImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatar = image
                }
            }
        }.resume()
    }
    
    func updateProfile() {
        guard let userId = authViewModel.currentUser?.id else { return }
        isLoading = true
        
        var updateData: [String: Any] = [
            "fullname": fullname
        ]
        
        if let avatar = avatar {
            uploadAvatar(avatar) { result in
                switch result {
                case .success(let url):
                    updateData["avatar"] = url.absoluteString
                    self.avatarURL = url
                    self.performUpdate(userId: userId, data: updateData)
                case .failure(let error):
                    self.showAlert(message: "Failed to upload avatar: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        } else {
            performUpdate(userId: userId, data: updateData)
        }
    }

    private func performUpdate(userId: String, data: [String: Any]) {
        db.collection("users").document(userId).updateData(data) { error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.showAlert(message: "Failed to update profile: \(error.localizedDescription)")
                } else {
                    self.showAlert(message: "Profile updated successfully")
                    self.authViewModel.updateCurrentUserAvatar(self.avatarURL)
                }
            }
        }
    }
    
    private func uploadAvatar(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "EditProfileViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        guard let userId = authViewModel.currentUser?.id else {
            completion(.failure(NSError(domain: "EditProfileViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("avatars/\(userId)/profile.jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "EditProfileViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }




    
    func removeProfilePicture() {
        avatar = nil
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
