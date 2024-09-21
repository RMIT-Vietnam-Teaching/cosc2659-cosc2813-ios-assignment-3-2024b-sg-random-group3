import SwiftUI
import FirebaseStorage

struct CreatePostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedCategory: SubjectCategory = .mathematics
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var isUploading = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    VStack(spacing: 15) {
                        titleField
                        contentField(geometry: geometry)
                        imageSection
                        tagsField
                        categoryPicker
                        createButton
                    }
                    .padding()
                    .background(Color.customBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.customSecondary.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding()
            }
            .background(Color.customBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("Create Post")
            .alert(isPresented: $showingSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your post has been created successfully."),
                    dismissButton: .default(Text("OK")) {
                        clearFields()
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    private var headerView: some View {
        Text("Create Post")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.customTextPrimary)
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Title")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextField("Enter post title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private func contentField(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Content")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextEditor(text: $content)
                .frame(height: geometry.size.height * 0.3)
                .padding(8)
                .background(Color.customSecondary.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Image")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Button(action: {
                showingImagePicker = true
            }) {
                Text(image == nil ? "Add Image" : "Change Image")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.customPrimary)
                    .cornerRadius(10)
            }
        }
    }
    
    private var tagsField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Tags")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextField("Enter tags (comma-separated)", text: $tags)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            Picker("Subject Category", selection: $selectedCategory) {
                ForEach(SubjectCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.customSecondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private var createButton: some View {
        Button(action: createPost) {
            if isUploading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Create Post")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.customPrimary)
        .foregroundColor(.white)
        .font(.headline)
        .cornerRadius(10)
        .disabled(isUploading)
    }
    
    private func createPost() {
        guard let currentUser = authViewModel.currentUser else {
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
            isUploading = false
            if success {
                showingSuccessAlert = true
            } else {
                showError("Failed to create post. Please try again.")
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "CreatePostView", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("post_images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
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
                    completion(.failure(NSError(domain: "CreatePostView", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    private func clearFields() {
        title = ""
        content = ""
        tags = ""
        selectedCategory = .mathematics
        inputImage = nil
        image = nil
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingErrorAlert = true
    }
}
