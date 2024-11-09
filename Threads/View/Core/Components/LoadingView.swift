//
//  LoadingView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct LoadingView: View {
    
    var message: String?
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
            if let message = message {
                Text(message)
                    .fontWeight(.heavy)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.top, 15)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
    }
}
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
