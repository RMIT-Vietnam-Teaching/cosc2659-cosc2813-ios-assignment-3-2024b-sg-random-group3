import SwiftUI

struct CreatePostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedCategory: SubjectCategory = .mathematics
    @State private var showingSuccessAlert = false
    
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
                
                Section {
                    Button("Create Post") {
                        createPost()
                    }
                }
            }
            .navigationTitle("Create Post")
            .alert(isPresented: $showingSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your post has been created successfully."),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    func createPost() {
        guard let currentUser = authViewModel.currentUser else { return }
        
        postViewModel.createPost(
            title: title,
            content: content,
            authorId: currentUser.id,
            authorName: currentUser.fullname,
            tags: tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            imageURL: nil,
            subjectCategory: selectedCategory,
            isAdminPost: currentUser.role == .admin
        ) { success in
            if success {
                showingSuccessAlert = true
            } else {
                // Handle error
                print("Create Post Error")
            }
        }
    }
}
