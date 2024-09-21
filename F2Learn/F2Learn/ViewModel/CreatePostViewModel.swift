import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class CreatePostViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var tags = ""
    @Published var selectedCategory: SubjectCategory = .mathematics
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var image: Image?
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isUploading = false
    
    private var postViewModel = PostViewModel()
    private let storage = Storage.storage()
    
    func createPost(currentUser: User?) {
        guard let currentUser = currentUser else {
            showError("User not authenticated")
            return
        }
        
        guard !title.isEmpty && !content.isEmpty else {
            showError("Please fill in all required fields")
            return
        }
        
        isUploading = true
        
        if let inputImage = inputImage {
            uploadImage(inputImage) { result in
                switch result {
                case .success(let url):
                    self.createPostWithImage(imageURL: url.absoluteString, currentUser: currentUser)
                case .failure(let error):
                    self.showError("Failed to upload image: \(error.localizedDescription)")
                    self.isUploading = false
                }
            }
        } else {
            createPostWithImage(imageURL: nil, currentUser: currentUser)
        }
    }
    
    private func createPostWithImage(imageURL: String?, currentUser: User) {
        postViewModel.createPost(
            title: title,
            content: content,
            authorId: currentUser.id,
            authorName: currentUser.fullname,
            tags: tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            imageURL: imageURL,
            subjectCategory: selectedCategory,
            isAdminPost: currentUser.role == .admin
        ) { success in
            self.isUploading = false
            if success {
                self.showSuccess("Your post has been created successfully.")
                self.clearFields()
            } else {
                self.showError("Failed to create post. Please try again.")
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            completion(.failure(NSError(domain: "CreatePostViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let storageRef = storage.reference().child("post_images/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("Starting image upload...")
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            print("Image uploaded successfully, fetching download URL...")
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let url = url {
                    print("Download URL obtained: \(url.absoluteString)")
                    completion(.success(url))
                } else {
                    print("No error, but also no download URL")
                    completion(.failure(NSError(domain: "CreatePostViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    func clearFields() {
        title = ""
        content = ""
        tags = ""
        selectedCategory = .mathematics
        inputImage = nil
        image = nil
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private func showError(_ message: String) {
        alertTitle = "Error"
        alertMessage = message
        showingAlert = true
    }
    
    private func showSuccess(_ message: String) {
        alertTitle = "Success"
        alertMessage = message
        showingAlert = true
    }
}
