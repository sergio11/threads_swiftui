//
//  ActivityView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct ActivityView: View {
    
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            ActivityViewContent(
                notifications: viewModel.notifications
            )
            .refreshable {
                viewModel.fetchData()
            }
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fetchData()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.black)
                            .imageScale(.small)
                    }
                }
            }.onAppear {
                viewModel.fetchData()
            }
            .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
        }
    }
}

private struct ActivityViewContent: View {
    
    var notifications: [NotificationBO]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(notifications) { notification in
                    NotificationCell(notification: notification, onProfileImageTapped: {
                        AnyView(ProfileView(user: notification.byUser))
                    })
                }
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}