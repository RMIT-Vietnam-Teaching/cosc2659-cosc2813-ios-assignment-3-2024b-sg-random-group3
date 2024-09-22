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

struct ChangePasswordView: View {
    @StateObject private var viewModel = ChangePasswordViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    VStack(spacing: 20) {
                        passwordField(title: "Current Password", text: $viewModel.currentPassword)
                        passwordField(title: "New Password", text: $viewModel.newPassword)
                        passwordField(title: "Confirm New Password", text: $viewModel.confirmNewPassword)
                        
                        changePasswordButton
                    }
                    .padding()
                    .background(Color.customBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.customSecondary.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .background(Color.customBackground.edgesIgnoringSafeArea(.all))
        }
        .navigationTitle("Change Password")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.successMessage != nil ? "Success" : "Error"),
                message: Text(viewModel.successMessage ?? viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK")) {
                    if viewModel.successMessage != nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
    
    private var headerView: some View {
        Text("Change Your Password")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.customTextPrimary)
    }
    
    private func passwordField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.customTextSecondary)
            SecureField(title, text: text)
                .padding()
                .background(Color.customSecondary.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.customTextPrimary)
        }
    }
    
    private var changePasswordButton: some View {
        Button(action: {
            viewModel.changePassword { _ in }
        }) {
            Text("Change Password")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customPrimary)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
        }
        .disabled(viewModel.isLoading)
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        )
    }
}
