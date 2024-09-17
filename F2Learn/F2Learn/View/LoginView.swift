import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            // App Icon
            Image("appPic")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding(.vertical, 32)
            
            VStack(spacing: 24){
                // Email Input
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@gmail.com")
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color.white)  // White background for input
                .cornerRadius(10)
                .shadow(radius: 5)
                
                // Password Input
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign In Button
            Button {
                login() // Your login function
            } label: {
                HStack {
                    Text("SIGN IN")
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
            
            // Navigation to Sign Up
            NavigationLink {
                SignUpView()
            } label: {
                HStack(spacing: 3){
                    Text("Don't Have An Account?")
                        .foregroundColor(.gray) // Neutral color
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(Color("secondarycolor")) // Secondary color from asset
                }
                .font(.system(size: 14))
            }
        }
        .padding()
        .background(Color("bgcolor").edgesIgnoringSafeArea(.all)) // Background color from asset
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Log In"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
