//
//  ExploreView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()

    var body: some View {
        content
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search users")
            .navigationDestination(for: UserBO.self) { user in
                ProfileView(user: user)
            }
    }
    
    /// Main content of the ExploreView
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.users) { user in
                    userNavigationLink(for: user)
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Creates a NavigationLink for each user cell
    /// - Parameter user: The user object to display.
    /// - Returns: A view containing the NavigationLink.
    @ViewBuilder
    private func userNavigationLink(for user: UserBO) -> some View {
        NavigationLink(value: user) {
            UserCell(user: user)
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

