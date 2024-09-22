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

struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowingLogin = false
    @State private var isShowingSignup = false
    
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
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        
                        Text("F2Learn")
                            .font(.system(size: min(geometry.size.width * 0.1, 40), weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Empowering Education in Vietnam")
                            .font(.system(size: min(geometry.size.width * 0.04, 18), weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer(minLength: 30)
                        
                        VStack(spacing: 20) {
                            Button(action: { isShowingLogin = true }) {
                                Text("Log In")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(Color.customPrimary)
                                    .font(.headline)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }
                            
                            Button(action: { isShowingSignup = true }) {
                                Text("Sign Up")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.customAccent)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    .padding(.horizontal)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingLogin) {
            LoginView()
        }
        .fullScreenCover(isPresented: $isShowingSignup) {
            SignUpView()
        }
    }
}
