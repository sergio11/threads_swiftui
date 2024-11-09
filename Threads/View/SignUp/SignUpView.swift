//
//  SignUpView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            BackgroundImage(imageName: "main_background")
            VStack {
                Spacer()
                SingUpContent()
                Spacer()
                SignUpForm()
                SingUpButton()
                Spacer()
                Divider()
                SignInLinkButton()
                DeveloperCreditView()
            }.padding()
        }.statusBar(hidden: true)
    }
}

private struct SingUpContent: View {
    var body: some View {
        VStack {
            Image("app_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            Text("onnect with others, share your moments, and be part of a real-time community.")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.horizontal, 30)
        
    }
}

private struct SignUpForm: View {
    
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter your email", text: $viewModel.email)
                .modifier(ThreadsTextFieldModifier())
            
            SecureField("Enter your password", text: $viewModel.password)
                .modifier(ThreadsTextFieldModifier())
            
            SecureField("Repeat your password", text: $viewModel.repeatPassword)
                .modifier(ThreadsTextFieldModifier())
            
            TextField("Enter your full name", text: $viewModel.fullname)
                .modifier(ThreadsTextFieldModifier())
            
            TextField("Enter your username", text: $viewModel.username)
                .autocapitalization(.none)
                .modifier(ThreadsTextFieldModifier())
        }
    }
    
}

private struct SingUpButton: View {
    
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        Button {
            viewModel.signUp()
        } label: {
            Text("Sign Up")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 352, height: 44)
                .background(.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
        }.padding(.vertical)
    }
}

private struct SignInLinkButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 3) {
                Text("Already have an account?")
                Text("Sign In")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.footnote)
        }
        .padding(.vertical, 16)
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
