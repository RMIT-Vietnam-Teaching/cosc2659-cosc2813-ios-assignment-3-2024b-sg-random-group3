import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Image("AppLogo") // Replace with your app logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                    
                    Text("Join F2learn")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.colors.primary)
                    
                    VStack(spacing: 15) {
                        CustomTextField(text: $viewModel.fullName, placeholder: "Full Name", icon: "person")
                        CustomTextField(text: $viewModel.email, placeholder: "Email", icon: "envelope")
                        CustomTextField(text: $viewModel.phoneNumber, placeholder: "Phone Number (Optional)", icon: "phone")
                        CustomSecureField(text: $viewModel.password, placeholder: "Password", icon: "lock")
                        CustomSecureField(text: $viewModel.confirmPassword, placeholder: "Confirm Password", icon: "lock")
                    }
                    
                    Button(action: {
                        viewModel.signUp { success in
                            if success {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.colors.onPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.colors.primary)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    HStack {
                        Text("Already have an account?")
                        Button("Log In") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(themeManager.colors.accent)
                    }
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .background(themeManager.colors.background.ignoresSafeArea())
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Sign Up"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.colors.onSurface)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(themeManager.colors.surface)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(themeManager.colors.onSurface.opacity(0.3), lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.colors.onSurface)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(themeManager.colors.surface)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(themeManager.colors.onSurface.opacity(0.3), lineWidth: 1)
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
                .environmentObject(ThemeManager())
                .previewDisplayName("Light Mode")
            
            SignUpView()
                .environmentObject(ThemeManager())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
