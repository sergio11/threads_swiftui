//
//  ForgotPasswordView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/11/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject var viewModel = ForgotPasswordViewModel()
    
    @Environment(\.dismiss) private var onDismiss
    
    var body: some View {
        ZStack {
            BackgroundImage(imageName: "main_background")
            VStack {
                Spacer()
                ForgotPasswordContent()
                Spacer()
                ForgotPasswordFormView(email: $viewModel.email)
                Spacer()
                SendResetLinkButtonView(onSendLink: {
                    viewModel.sendResetLink()
                })
                Spacer()
                Divider()
                SignInLinkView()
                DeveloperCreditView()
            }.padding()
        }
        .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
        .alert(isPresented: $viewModel.resetLinkSent) {
            Alert(
                title: Text("Success"),
                message: Text("We have sent a password reset link to your email."),
                dismissButton: .default(Text("OK"), action: {
                    onDismiss()
                })
            )
        }
        .environment(\.colorScheme, .light)
    }
}

private struct ForgotPasswordContent: View {
    var body: some View {
        VStack {
            Image("app_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            Text("Forgot Password?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            Text("Enter your email address, and we’ll send you a link to reset your password.")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.horizontal, 30)
    }
}

private struct ForgotPasswordFormView: View {
    
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter your email", text: $email)
                .autocapitalization(.none)
                .modifier(ThreadsTextFieldModifier())
        }
    }
}

private struct SendResetLinkButtonView: View {
    
    var onSendLink: () -> Void

    var body: some View {
        Button {
            onSendLink()
        } label: {
            Text("Send Reset Link")
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

private struct SignInLinkView: View {
    
    var body: some View {
        NavigationLink {
            SignInView()
                .navigationBarBackButtonHidden(true)
        } label: {
            HStack(spacing: 3) {
                Text("Remember your password?")
                Text("Sign In")
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.footnote)
        }.padding(.vertical, 16)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
