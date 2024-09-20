import SwiftUI
import Firebase
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
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
                        
                        Text("Reset Password")
                            .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Enter your email address and we'll send you a link to reset your password.")
                            .font(.system(size: min(geometry.size.width * 0.04, 16)))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
                            .padding(.horizontal)
                        
                        Button(action: resetPassword) {
                            Text("Send Reset Link")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color.customPrimary)
                                .font(.headline)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Back to Login")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address."
            showAlert = true
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Password reset email sent. Please check your inbox."
            }
            showAlert = true
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
