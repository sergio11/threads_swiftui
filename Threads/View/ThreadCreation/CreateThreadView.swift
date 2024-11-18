//
//  CreateThreadView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct CreateThreadView: View {
    
    @StateObject var viewModel = CreateThreadViewModel()
    @Environment(\.dismiss) private var onDismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(profileImageUrl: viewModel.authUserProfileImageUrl, size: .small)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.authUserUsername)
                            .fontWeight(.semibold)
                        TextField("Start a thread ...", text: $viewModel.caption, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !viewModel.caption.isEmpty {
                        Button {
                            viewModel.caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        viewModel.uploadThread()
                        onDismiss()
                    }
                    .opacity(viewModel.caption.isEmpty ? 0.5 : 1.0)
                    .disabled(viewModel.caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
            .onReceive(viewModel.$threadUploaded) { success in
                if success {
                    onDismiss()
                }
            }
        }
    }
}

struct CreateThreadView_Previews: PreviewProvider {
    static var previews: some View {
        CreateThreadView()
    }
}

