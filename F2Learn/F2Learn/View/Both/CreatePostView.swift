import SwiftUI

struct CreatePostView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                        clearButton
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
        .navigationTitle("Create Post")
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    if viewModel.alertTitle == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
    }
    
    private var headerView: some View {
        Text("Share Your Knowledge")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.customTextPrimary)
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Title")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextField("Enter post title", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private func contentField(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Content")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextEditor(text: $viewModel.content)
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
           
           if let image = viewModel.image {
               image
                   .resizable()
                   .scaledToFit()
                   .frame(height: 200)
                   .cornerRadius(10)
           }
           
           Button(action: {
               viewModel.showingImagePicker = true
           }) {
               Text(viewModel.image == nil ? "Add Image" : "Change Image")
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
            TextField("Enter tags (comma-separated)", text: $viewModel.tags)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            Picker("Subject Category", selection: $viewModel.selectedCategory) {
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
        Button(action: {
            viewModel.createPost(currentUser: authViewModel.currentUser)
        }) {
            Text(viewModel.isUploading ? "Creating..." : "Create Post")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customPrimary)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
        }
        .disabled(viewModel.isUploading)
    }
    
    private var clearButton: some View {
        Button(action: viewModel.clearFields) {
            Text("Clear")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customSecondary)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
        }
    }
}
