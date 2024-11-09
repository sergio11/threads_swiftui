//
//  SnackbarView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct SnackbarView: View {
    @Binding var message: String?
    var duration: Double = 5.0  // Duration before hiding the snackbar
    
    var body: some View {
        if let message = message, !message.isEmpty {
            VStack {
                Spacer()
                Text(message)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        // Hide the snackbar after the given duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                self.message = nil
                            }
                        }
                    }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            .animation(.easeInOut, value: message)
        }
    }
}
