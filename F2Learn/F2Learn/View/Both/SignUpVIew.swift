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
    @State private var navigateToLogin = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.customPrimary, Color.customSecondary]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Logo
                        Image("F2Learn")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: min(geometry.size.width * 0.4, 150), height: min(geometry.size.width * 0.4, 150))
                            .background(Circle().fill(Color.white).shadow(radius: 10))
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        
                        Text("Create Account")
                            .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 15) {
                            LoginTextField(text: $fullname, placeholder: "Full Name", icon: "person")
                            LoginTextField(text: $email, placeholder: "Email", icon: "envelope")
                            LoginTextField(text: $phone, placeholder: "Phone", icon: "phone")
                            CustomSecureField(text: $password, placeholder: "Password", icon: "lock")
                            CustomSecureField(text: $confirmPassword, placeholder: "Confirm Password", icon: "lock")
                        }
                        
                        Button(action: signUp) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color.customPrimary)
                                .font(.headline)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white)
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Log In")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
    
    private func signUp() {
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        authViewModel.signUp(fullname: fullname, email: email, phone: phone, password: password) { success, error in
            if success {
                alertMessage = "Sign up successful! Please log in."
                showAlert = true
                navigateToLogin = true
            } else {
                alertMessage = error ?? "An unknown error occurred"
                showAlert = true
            }
        }
    }
}
