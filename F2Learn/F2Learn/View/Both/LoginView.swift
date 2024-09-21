import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingForgotPassword = false
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
                        
                        Text("F2Learn")
                            .font(.system(size: min(geometry.size.width * 0.1, 40), weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 20) {
                            LoginTextField(text: $email, placeholder: "Email", icon: "envelope")
                            CustomSecureField(text: $password, placeholder: "Password", icon: "lock")
                            
                            Button(action: login) {
                                Text("Log In")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(Color.customPrimary)
                                    .font(.headline)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }
                            
                            Button(action: { isShowingForgotPassword = true }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.white)
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Log In"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShowingForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    private func login() {
        authViewModel.signIn(email: email, password: password) { success, error in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = error ?? "An unknown error occurred"
                showAlert = true
            }
        }
    }
}
