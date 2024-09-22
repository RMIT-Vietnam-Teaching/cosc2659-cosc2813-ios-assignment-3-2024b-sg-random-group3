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

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation: Double = 0
    @State private var currentInfoIndex = 0
    
    let appInfo = [
        "Empowering Education in Vietnam",
        "Connect with Educators and Students",
        "Share Knowledge and Experiences",
        "Learn from Expert-Curated Content"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.customPrimary, Color.customSecondary]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("F2Learn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.6, 300), height: min(geometry.size.width * 0.6, 300))
                        .background(Circle().fill(Color.white).shadow(radius: 10))
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(size)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1.5), value: size)
                    
                    Text("F2Learn")
                        .font(.system(size: min(geometry.size.width * 0.1, 60), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1.5), value: opacity)
                    
                    Text(appInfo[currentInfoIndex])
                        .font(.system(size: min(geometry.size.width * 0.04, 24), weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: 60)
                        .transition(.opacity)
                        .id(currentInfoIndex)
                    
                    HStack(spacing: 10) {
                        ForEach(0..<appInfo.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentInfoIndex ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentInfoIndex ? 1.2 : 1.0)
                                .animation(.spring(), value: currentInfoIndex)
                        }
                    }
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.top, 20)
                        .opacity(opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.size = 1.0
                self.opacity = 1.0
            }
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.rotation = 360
            }
            startInfoCycle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation {
                    self.isActive = false
                }
            }
        }
    }
    
    private func startInfoCycle() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            withAnimation {
                currentInfoIndex = (currentInfoIndex + 1) % appInfo.count
            }
            if !isActive {
                timer.invalidate()
            }
        }
    }
}
