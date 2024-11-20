//
//  ExploreView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()

    var body: some View {
        NavigationStack {
            content
                // Set navigation title for the screen
                .navigationTitle("Explore Users")
                // Add searchable functionality to filter users
                .searchable(text: $viewModel.searchText, prompt: "Search for users by name")
                // Show loading and error overlay if applicable
                .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
                .onAppear {
                    // Load current user data when the view appears
                    viewModel.loadCurrentUser()
                }
        }
    }
    
    private var content: some View {
        VStack {
            // Show empty state when there is no search text or no users found
            if viewModel.searchText.isEmpty || viewModel.users.isEmpty {
                emptyStateView
            } else {
                // Show the list of users when there are search results
                ScrollView {
                    LazyVStack(spacing: 8) {
                        // Iterate over the list of users and create a navigation link for each
                        ForEach(viewModel.users) { user in
                            userNavigationLink(for: user)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 20)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            // Display different icons based on whether there is search text or not
            Image(systemName: viewModel.searchText.isEmpty ? "magnifyingglass" : "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            // Show appropriate empty state message
            Text(viewModel.searchText.isEmpty ? "Start searching for users" : "No results found")
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }

    @ViewBuilder
    private func userNavigationLink(for user: UserBO) -> some View {
        // Navigation link to user profile view
        NavigationLink(destination: ProfileView(user: user)) {
            // User cell that shows user info and follow status
            UserCell(user: user, isFollowing: viewModel.isUserFollowing(user: user))
                .padding(.vertical, 4)
                .background(Divider(), alignment: .bottom)
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
