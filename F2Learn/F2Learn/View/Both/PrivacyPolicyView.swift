/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Random Group 3/F2 Learn
  ID: Tran Ngoc Minh – s3911737
      Nguyen Duong Truong Thinh – s3914412
      Dang Minh Triet – s4022878
      Du Tuan Vu – s3924489
  Created  date:  26/08/2024
  Last modified:  23/09/2024
  Acknowledgement: RMIT Canvas( tutorials, modules)
*/


import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.customTextPrimary)
                    
                    Group {
                        sectionTitle("1. Information We Collect")
                        sectionContent("We collect personal information that you provide directly to us, such as your name, email address, and profile information.")
                        
                        sectionTitle("2. How We Use Your Information")
                        sectionContent("We use your information to provide, maintain, and improve our services, and to communicate with you.")
                        
                        sectionTitle("3. Information Sharing and Disclosure")
                        sectionContent("We do not sell your personal information. We may share information with third-party service providers who perform services on our behalf.")
                        
                        sectionTitle("4. Data Security")
                        sectionContent("We implement reasonable security measures to protect your personal information from unauthorized access or disclosure.")
                        
                        sectionTitle("5. Your Rights and Choices")
                        sectionContent("You may access, update, or delete your account information at any time through your account settings.")
                        
                        sectionTitle("6. Changes to This Privacy Policy")
                        sectionContent("We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.")
                        
                        sectionTitle("7. Contact Us")
                        sectionContent("If you have any questions about this Privacy Policy, please contact us at privacy@f2learn.com.")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
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
