import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome back to the app")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 15) {
                InputView(text: $email, title: "Email Address", placeholder: "hello@example.com")
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)

                HStack {
                    Spacer()
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(Color.blue)
                        .onTapGesture {
                            // Forgot password action
                        }
                }
                
                Toggle(isOn: .constant(true)) {
                    Text("Keep me signed in")
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            }
            .padding(.horizontal, 40)

            Button(action: {
                // Login action
            }) {
                Text("Login")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            
            Text("or sign in with")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Social login action
            }) {
                HStack {
                    Image(systemName: "globe") // Replace with Google icon
                    Text("Continue with Google")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(25)
                .padding(.horizontal, 40)
            }

            NavigationLink(destination: SignUpView()) {
                Text("Create an account")
                    .font(.subheadline)
                    .foregroundColor(Color.blue)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
