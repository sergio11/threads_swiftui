//
//  EditProfileView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @StateObject var viewModel = EditProfileViewModel()
    @Environment(\.dismiss) private var onDimiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                            TextField("Enter your fullname ...", text: $viewModel.authUserFullName, axis: .vertical)
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(profileImageUrl: viewModel.authUserProfileImageUrl, size: .small)
                            }
                        }
                        
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                        
                        TextField("Enter your bio ...", text: $viewModel.bio, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Link")
                            .fontWeight(.semibold)
                        
                        TextField("Add link ...", text: $viewModel.link)
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    Toggle("Private Profile", isOn: $viewModel.isPrivateProfile)
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
                
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDimiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.onUpdateProfile()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
            .onReceive(viewModel.$userProfileUpdated) { success in
                if success {
                    onDimiss()
                }
            }
            .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
            .onAppear {
                viewModel.loadCurrentUser()
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
