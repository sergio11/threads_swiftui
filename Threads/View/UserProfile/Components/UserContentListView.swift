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
            HStack {
                ForEach(ProfileThreadFilter.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedFilter == filter ? .bold : .regular)
                            
                        if viewModel.selectedFilter == filter {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.selectedFilter = filter
                        }
                    }
                }
            }
            
            LazyVStack {
                ForEach(viewModel.threads) { thread in
                    ThreadCell(thread: thread)
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            viewModel.loadUser(user: user)
            viewModel.fetchUserThreads()
        }
    }
}

struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(user: dev.user)
    }
}
