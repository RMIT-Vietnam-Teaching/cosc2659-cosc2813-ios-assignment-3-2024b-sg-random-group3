import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullname = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.customBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        titleText
                        fullnameField
                        emailField
                        phoneField
                        passwordField
                        confirmPasswordField
                        signUpButton
                        loginLink
                    }
                    .padding(.horizontal, 30)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var titleText: some View {
        Text("Create Account")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.customTextPrimary)
            .padding(.top, 50)
    }
    
    private var fullnameField: some View {
        TextField("Full Name", text: $fullname)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.words)
            .padding()
            .background(Color.customBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customPrimary, lineWidth: 1)
            )
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
    
    private var phoneField: some View {
        TextField("Phone", text: $phone)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.phonePad)
            .padding()
            .background(Color.customBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customPrimary, lineWidth: 1)
            )
    }
    
    private var passwordField: some View {
        SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.customBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customPrimary, lineWidth: 1)
            )
    }
    
    private var confirmPasswordField: some View {
        SecureField("Confirm Password", text: $confirmPassword)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.customBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customPrimary, lineWidth: 1)
            )
    }
    
    private var signUpButton: some View {
        Button(action: signUp) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
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
    
    private var loginLink: some View {
        NavigationLink(destination: LoginView()) {
            Text("Already have an account? Log In")
                .foregroundColor(.customPrimary)
        }
    }
    
    private func signUp() {
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        isLoading = true
        authViewModel.signUp(fullname: fullname, email: email, phone: phone, password: password) { success, error in
            isLoading = false
            if success {
                alertMessage = "Sign up successful!"
            } else {
                alertMessage = error ?? "An unknown error occurred"
            }
            showAlert = true
        }
    }
}
