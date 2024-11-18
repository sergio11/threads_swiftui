//
//  ProfileView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    var user: UserBO?
        
    init(user: UserBO?) {
        self.user = user
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ProfileHeaderView(user: viewModel.user)
                if viewModel.isAuthUser {
                    Button {
                        viewModel.showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 352, height: 32)
                            .background(.white)
                            .cornerRadius(8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                } else {
                    Button {
                        
                    } label: {
                       Text("Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 352, height: 32)
                            .background(.black)
                            .cornerRadius(8)
                    }
                }
            
                if let user = viewModel.user {
                    UserContentListView(user: user)
                }
            }
        }
        .sheet(isPresented: $viewModel.showEditProfile, content: {
            if let user = viewModel.user {
                EditProfileView(user: user)
            }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.signOut()
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .onAppear {
            if let user = user {
                viewModel.loadUser(user: user)
            } else {
                viewModel.loadCurrentUser()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
