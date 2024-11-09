//
//  SignInView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            BackgroundImage(imageName: "main_background")
            VStack {
                Spacer()
                SingInContent()
                Spacer()
                SignInFormView()
                ForgotPasswordLinkView()
                SignInButtonView()
                Spacer()
                Divider()
                SignUpLinkView()
                DeveloperCreditView()
            }.padding()
        }
        .statusBar(hidden: true)
    }
}

private struct SingInContent: View {
    var body: some View {
        VStack {
            Image("app_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            Text("Welcome to Threads")
                 .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            Text("Join the conversation. Share your thoughts and connect with friends in real time.")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.horizontal, 30)
        
    }
}

private struct SignInFormView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter your email", text: $viewModel.email)
                .autocapitalization(.none)
                .modifier(ThreadsTextFieldModifier())
        
            SecureField("Enter you password", text: $viewModel.password)
                .modifier(ThreadsTextFieldModifier())
        }
    }
}

private struct ForgotPasswordLinkView: View {

    var body: some View {
        NavigationLink {
            Text("Forgot password")
        } label: {
            Text("Forgot Password?")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical)
                .padding(.trailing, 28)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private struct SignInButtonView: View {
    
    @StateObject var viewModel = SignInViewModel()

    var body: some View {
        Button {
            viewModel.signIn()
        } label: {
            Text("Login")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 352, height: 44)
                .background(Color.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}

private struct SignUpLinkView: View {
    
    var body: some View {
        NavigationLink {
            SignUpView()
                .navigationBarBackButtonHidden(true)
        } label: {
            HStack(spacing: 3) {
                Text("Don't have an account?")
                Text("Sign Up")
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.footnote)
        }.padding(.vertical, 16)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
