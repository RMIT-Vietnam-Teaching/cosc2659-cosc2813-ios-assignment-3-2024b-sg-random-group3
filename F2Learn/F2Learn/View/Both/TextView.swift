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

struct LoginTextField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .autocapitalization(.none)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 20)
            SecureField(placeholder, text: $text)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var isDisabled: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.customSecondary)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .foregroundColor(.customTextPrimary)
                .disabled(isDisabled)
        }
        .padding()
        .background(Color.customSecondary.opacity(0.1))
        .cornerRadius(10)
    }
}
