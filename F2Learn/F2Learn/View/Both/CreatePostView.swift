import SwiftUI

struct CreatePostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedCategory: SubjectCategory = .mathematics
    @State private var showingSuccessAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        titleField
                        contentField(geometry: geometry)
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
        }
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your post has been created successfully."),
                dismissButton: .default(Text("OK")) {
                    clearFields()
                }
            )
        }
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
            Text("Create Post")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customPrimary)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
        }
    }
    
    private func createPost() {
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
    
    private func clearFields() {
        title = ""
        content = ""
        tags = ""
        selectedCategory = .mathematics
    }
}
