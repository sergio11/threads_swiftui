//
//  UserContentListView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import SwiftUI

struct UserContentListView: View {
    
    @StateObject var viewModel = UserContentListViewModel()
    @Namespace var animation
    
    // Width calculation for the filter bar
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileThreadFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    let user: UserBO
    

    init(user: UserBO) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            // Filter Bar
            HStack {
                // Loop through all available filters
                ForEach(ProfileThreadFilter.allCases) { filter in
                    VStack {
                        // Title for each filter
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedFilter == filter ? .bold : .regular)
                        
                        // Show the active selection indicator (underline) for the selected filter
                        if viewModel.selectedFilter == filter {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            // Invisible rectangle when the filter is not selected
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    }
                    .onTapGesture {
                        // Animate filter selection change when tapped
                        withAnimation(.spring()) {
                            viewModel.selectedFilter = filter
                        }
                    }
                }
            }
            
            // Threads List
            if viewModel.threads.isEmpty {
                emptyStateView
            } else {
                LazyVStack {
                    ForEach(viewModel.threads) { thread in
                        ThreadCell(thread: thread, onLikeTapped: {
                            viewModel.likeThread(threadId: thread.threadId)
                        })
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            viewModel.loadUser(user: user)
            viewModel.fetchUserThreads()
        }
    }
    
    // Empty State View shown when there are no threads
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "face.dashed.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("This user has no posts yet.")
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


struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(user: dev.user)
    }
}
