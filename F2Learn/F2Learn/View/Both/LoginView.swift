import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showForgotPassword = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.customBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        logoImage
                        welcomeText
                        emailField
                        passwordField
                        loginButton
                        forgotPasswordButton
                        signUpLink
                    }
                    .padding(.horizontal, 30)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    private var logoImage: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundColor(.customPrimary)
    }
    
    private var welcomeText: some View {
        Text("Welcome Back!")
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
    
    private var loginButton: some View {
        Button(action: login) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Log In")
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
    
    private var forgotPasswordButton: some View {
        Button(action: { showForgotPassword = true }) {
            Text("Forgot Password?")
                .foregroundColor(.customPrimary)
        }
    }
    
    private var signUpLink: some View {
        NavigationLink(destination: SignUpView()) {
            Text("Don't have an account? Sign Up")
                .foregroundColor(.customPrimary)
        }
    }
    
    private func login() {
        isLoading = true
        authViewModel.signIn(email: email, password: password) { success, error in
            isLoading = false
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = error ?? "An unknown error occurred"
                showAlert = true
            }
        }
    }
}
