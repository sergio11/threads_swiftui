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
                SignUpForm(
                    email: $viewModel.email,
                    password: $viewModel.password,
                    repeatPassword: $viewModel.repeatPassword,
                    fullname: $viewModel.fullname,
                    username: $viewModel.username
                )
                SingUpButton(onSignUp: {
                    viewModel.signUp()
                })
                Spacer()
                Divider()
                SignInLinkButton()
                DeveloperCreditView()
            }.padding()
        }
        .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
        .environment(\.colorScheme, .light)
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
            Text("Connect with others, share your moments, and be part of a real-time community.")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.horizontal, 30)
        
    }
}

private struct SignUpForm: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var repeatPassword: String
    @Binding var fullname: String
    @Binding var username: String
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter your email", text: $email)
                .modifier(ThreadsTextFieldModifier())
            
            SecureField("Enter your password", text: $password)
                .modifier(ThreadsTextFieldModifier())
            
            SecureField("Repeat your password", text: $repeatPassword)
                .modifier(ThreadsTextFieldModifier())
            
            TextField("Enter your full name", text: $fullname)
                .modifier(ThreadsTextFieldModifier())
            
            TextField("Enter your username", text: $username)
                .autocapitalization(.none)
                .modifier(ThreadsTextFieldModifier())
        }
    }
    
}

private struct SingUpButton: View {
    
    var onSignUp: () -> Void
    
    var body: some View {
        Button {
            onSignUp()
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
