import SwiftUI

struct SignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var fullname = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            TextField("Full Name", text: $fullname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
            
            TextField("Phone", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Sign Up") {
                signUp()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
                alertMessage = "Sign up successful!"
            } else {
                alertMessage = error ?? "An unknown error occurred"
            }
            showAlert = true
        }
    }
}
