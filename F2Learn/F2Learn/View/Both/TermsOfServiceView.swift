import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms of Service")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.customTextPrimary)
                    
                    Group {
                        sectionTitle("1. Acceptance of Terms")
                        sectionContent("By accessing or using F2Learn, you agree to be bound by these Terms of Service.")
                        
                        sectionTitle("2. Description of Service")
                        sectionContent("F2Learn is an educational platform designed to address educational disparities in Vietnam.")
                        
                        sectionTitle("3. User Accounts")
                        sectionContent("You are responsible for maintaining the confidentiality of your account and password.")
                        
                        sectionTitle("4. User Content")
                        sectionContent("You retain ownership of content you submit, but grant F2Learn a license to use, modify, and display that content.")
                        
                        sectionTitle("5. Prohibited Activities")
                        sectionContent("Users must not engage in any unlawful or harmful activities while using F2Learn.")
                        
                        sectionTitle("6. Termination")
                        sectionContent("F2Learn reserves the right to terminate or suspend access to the service without prior notice.")
                        
                        sectionTitle("7. Changes to Terms")
                        sectionContent("F2Learn may modify these terms at any time. Continued use of the service constitutes acceptance of the new terms.")
                        
                        sectionTitle("8. Disclaimer of Warranties")
                        sectionContent("F2Learn is provided 'as is' without any warranties, express or implied.")
                        
                        sectionTitle("9. Limitation of Liability")
                        sectionContent("F2Learn shall not be liable for any indirect, incidental, special, consequential or punitive damages.")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Terms of Service", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all))
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.customTextPrimary)
    }
    
    private func sectionContent(_ content: String) -> some View {
        Text(content)
            .font(.body)
            .foregroundColor(.customTextSecondary)
    }
}
