import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isShowingEditProfile = false
    @State private var isShowingChangePassword = false
    @State private var isShowingTerms = false
    @State private var isShowingPrivacyPolicy = false
    @State private var isShowingLogoutAlert = false
    @State private var pushNotifications = true
    @State private var emailNotifications = false
    @State private var makeProfilePrivate = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    profileSection
                    
                    settingsSection(geometry: geometry)
                    
                    aboutSection(geometry: geometry)
                    
                    logoutButton(geometry: geometry)
                }
                .padding()
            }
            .background(Color.customBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("Settings")
        }
        .alert(isPresented: $isShowingLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    authViewModel.signOut()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isShowingEditProfile) {
            EditProfileView(authViewModel: authViewModel)
        }
        .sheet(isPresented: $isShowingChangePassword) {
            ChangePasswordView()
        }
        .sheet(isPresented: $isShowingTerms) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $isShowingPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    private var profileSection: some View {
            HStack {
                if let avatarURL = authViewModel.currentUser?.avatar, let url = URL(string: avatarURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.customPrimary)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.customPrimary)
                }
                
                VStack(alignment: .leading) {
                    Text(authViewModel.currentUser?.fullname ?? "User")
                        .font(.title2)
                        .foregroundColor(.customTextPrimary)
                    Text(authViewModel.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.customTextSecondary)
                }
                
                Spacer()
                
                Button(action: { isShowingEditProfile = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.customPrimary)
                }
            }
            .padding()
            .background(Color.customSecondary.opacity(0.1))
            .cornerRadius(15)
        }
    
    private func settingsSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 15) {
            settingToggle(title: "Dark Mode", isOn: $isDarkMode)
            settingToggle(title: "Push Notifications", isOn: $pushNotifications)
            settingToggle(title: "Email Notifications", isOn: $emailNotifications)
            settingToggle(title: "Make Profile Private", isOn: $makeProfilePrivate)
            
            settingButton(title: "Change Password", icon: "lock", action: {
                isShowingChangePassword = true
            }, geometry: geometry)
        }
    }
    
    private func aboutSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 15) {
            settingButton(title: "Terms of Service", icon: "doc.text", action: {
                isShowingTerms = true
            }, geometry: geometry)
            
            settingButton(title: "Privacy Policy", icon: "hand.raised", action: {
                isShowingPrivacyPolicy = true
            }, geometry: geometry)
            
            HStack {
                Text("Version")
                    .foregroundColor(.customTextPrimary)
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.customTextSecondary)
            }
            .padding()
            .background(Color.customSecondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func settingToggle(title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .toggleStyle(SwitchToggleStyle(tint: .customPrimary))
            .padding()
            .background(Color.customSecondary.opacity(0.1))
            .cornerRadius(10)
    }
    
    private func settingButton(title: String, icon: String, action: @escaping () -> Void, geometry: GeometryProxy) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.customPrimary)
                    .frame(width: 30)
                Text(title)
                    .foregroundColor(.customTextPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.customTextSecondary)
            }
            .padding()
            .frame(width: geometry.size.width - 40)
            .background(Color.customSecondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func logoutButton(geometry: GeometryProxy) -> some View {
        Button(action: { isShowingLogoutAlert = true }) {
            Text("Logout")
                .foregroundColor(.white)
                .frame(width: geometry.size.width - 40, height: 50)
                .background(Color.red)
                .cornerRadius(10)
        }
    }
}
