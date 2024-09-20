import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                titleText
                emailField
                resetPasswordButton
            }
            .padding(.horizontal, 30)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage == "Password reset email sent successfully." {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    private var titleText: some View {
        Text("Reset Password")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.customTextPrimary)
    }
    
    private var emailField: some View {
        TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .padding()
            .background(Color.customBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customPrimary, lineWidth: 1)
            )
    }
    
    private var resetPasswordButton: some View {
        Button(action: resetPassword) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Reset Password")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customPrimary)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isLoading)
    }
    
    private func resetPassword() {
        isLoading = true
        // Implement password reset logic here
        // For example:
        // authViewModel.resetPassword(email: email) { success, error in
        //     isLoading = false
        //     if success {
        //         alertMessage = "Password reset email sent successfully."
        //     } else {
        //         alertMessage = error ?? "An error occurred while resetting the password."
        //     }
        //     showAlert = true
        // }
        
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            alertMessage = "Password reset email sent successfully."
            showAlert = true
        }
    }
}
