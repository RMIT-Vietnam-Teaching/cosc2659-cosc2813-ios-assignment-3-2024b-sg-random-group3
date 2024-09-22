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

struct CreatePostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedCategory: SubjectCategory = .mathematics
    @State private var showingSuccessAlert = false
    @State private var showingClearConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    titleField
                    contentField
                    tagsField
                    categoryPicker
                }
                .padding()
            }
            
            HStack {
                createButton
                clearButton
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your post has been created successfully."),
                dismissButton: .default(Text("OK")) {
                    clearFields()
                }
            )
        }
        .actionSheet(isPresented: $showingClearConfirmation) {
            ActionSheet(
                title: Text("Clear All Fields"),
                message: Text("Are you sure you want to clear all fields?"),
                buttons: [
                    .destructive(Text("Clear")) { clearFields() },
                    .cancel()
                ]
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
    
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Content")
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            TextEditor(text: $content)
                .frame(height: 200)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.customSecondary, lineWidth: 1))
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
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.customSecondary, lineWidth: 1))
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
    
    private var clearButton: some View {
        Button(action: { showingClearConfirmation = true }) {
            Text("Clear")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
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
