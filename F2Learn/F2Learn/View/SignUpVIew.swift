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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Back to login view
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color("primarycolor")) // Use primary color from assets
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
            }
            
            Spacer()
            
            // Input fields
            VStack(spacing: 24) {
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your full name")
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(Color.white)  // Input background
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@gmail.com")
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                InputView(text: $phone,
                          title: "Phone",
                          placeholder: "Enter your phone number")
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign up button
            Button {
                signUp()
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(Color("primarycolor")) // Primary color from asset
                .cornerRadius(10)
            }
            .padding(.top, 24)
            
            Spacer()
        }
        .padding()
        .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from asset
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
