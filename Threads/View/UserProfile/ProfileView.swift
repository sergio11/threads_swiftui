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
        NavigationStack {
            ProfileViewContent(
                user: viewModel.user,
                isAuthUser: viewModel.isAuthUser,
                showEditProfile: $viewModel.showEditProfile,
                onFollowUserTapped: {
                    viewModel.followUser()
                }
            )
            .refreshable {
                loadData()
            }
            .sheet(isPresented: $viewModel.showEditProfile, onDismiss: {
                loadData()
            }, content: {
                EditProfileView()
            })
            .toolbar {
                if viewModel.isAuthUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.showSignOutAlert.toggle()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.black)
                                .imageScale(.small)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
            .onAppear {
                loadData()
            }
            .alert(isPresented: $viewModel.showSignOutAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Do you really want to sign out?"),
                    primaryButton: .destructive(Text("Sign Out")) {
                        viewModel.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func loadData() {
        if let user = user {
            viewModel.loadUser(user: user)
        } else {
            viewModel.loadCurrentUser()
        }
    }
}

private struct ProfileViewContent: View {
    
    var user: UserBO?
    var isAuthUser: Bool
    @Binding var showEditProfile: Bool
    
    var onFollowUserTapped: (() -> Void)?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ProfileHeaderView(user: user)
                if isAuthUser {
                    Button {
                        showEditProfile.toggle()
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
                        onFollowUserTapped?()
                    } label: {
                        Text(user?.isFollowedByAuthUser ?? false ? "Following": "Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 352, height: 32)
                            .background(.black)
                            .cornerRadius(8)
                    }
                }
                
                if let user = user {
                    UserContentListView(user: user)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
