import SwiftUI

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
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 200)
                    TextField("Tags (comma-separated)", text: $tags)
                }
                
                Section(header: Text("Category")) {
                    Picker("Subject Category", selection: $selectedCategory) {
                        ForEach(SubjectCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Image")) {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Button("Select Image") {
                        showingImagePicker = true
                    }
                }
                
                Section {
                    Button("Create Post") {
                        createPost()
                    }
                }
            }
            .navigationTitle("Create Post")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func createPost() {
        guard let currentUser = authViewModel.currentUser else { return }
        
        // TODO: Implement image upload and get the URL
        let imageURL: String? = nil
        
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
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                // Show error message
            }
        }
    }
}
