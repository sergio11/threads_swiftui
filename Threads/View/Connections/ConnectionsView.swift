//
//  ConnectionsView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import SwiftUI

struct ConnectionsView: View {
    
    @StateObject var viewModel = ConnectionsViewModel()
    
    var userId: String
    var connectionType: UserConnectionType
    
    var body: some View {
        NavigationStack {
            ConnectionsViewContent(
                users: viewModel.users,
                onFollowTapped: { userId in
                    viewModel.followUser(userId: userId)
                }
            )
            .padding(.top)
            .refreshable {
                viewModel.fetchData(userId: userId, connectionType: connectionType)
            }
            .navigationTitle(connectionType == .followers ? "Followers" : "Following")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fetchData(userId: userId, connectionType: connectionType)
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.black)
                            .imageScale(.small)
                    }
                }
            }
            .onAppear {
                viewModel.fetchData(userId: userId, connectionType: connectionType)
            }
            .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
        }
    }
}

private struct ConnectionsViewContent: View {
    
    var users: [UserBO]
    var onFollowTapped: (String) -> Void
    
    var body: some View {
        VStack {
            if users.isEmpty {
                emptyStateView
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(users) { user in
                            UserCell(
                                user: user,
                                onFollowTapped: {
                                    onFollowTapped(user.id)
                                },
                                onProfileImageTapped: {
                                    AnyView(ProfileView(user: user))
                                }
                            )
                            .padding(.vertical, 4)
                            .background(Divider(), alignment: .bottom)
                        }
                    }
                }
            }
        }
    }
    
    // Empty State View shown when there are no users (followers or following)
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "person.3.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No connections yet.")
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal)
        }
        .padding(.vertical, 30)
        .background(Color.white)
    }
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView(userId: "", connectionType: .followers)
    }
}
