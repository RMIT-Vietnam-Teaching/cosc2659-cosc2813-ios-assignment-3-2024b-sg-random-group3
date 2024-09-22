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

struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    
    init(authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(authViewModel: authViewModel))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        profileImageSection
                        personalInfoSection
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Profile Update"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.alertMessage.contains("successfully") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Change Profile Picture"),
                    buttons: [
                        .default(Text("Choose from Library")) {
                            showingImagePicker = true
                        },
                        .destructive(Text("Remove Current Picture")) {
                            viewModel.removeProfilePicture()
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.avatar)
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.4))
                    }
                }
            )
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            if let avatar = viewModel.avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.customPrimary, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.customSecondary)
            }
            
            Button(action: {
                showingActionSheet = true
            }) {
                Text("Change Profile Picture")
                    .foregroundColor(.customPrimary)
                    .padding(.vertical, 8)
            }
        }
    }
    
    private var personalInfoSection: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $viewModel.fullname, placeholder: "Full Name", icon: "person")
            CustomTextField(text: .constant(viewModel.email), placeholder: "Email", icon: "envelope", isDisabled: true)
            CustomTextField(text: .constant(viewModel.phone), placeholder: "Phone", icon: "phone", isDisabled: true)
        }
    }
    
    private var saveButton: some View {
        Button(action: viewModel.updateProfile) {
            Text("Save Changes")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customPrimary)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(viewModel.isLoading)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


