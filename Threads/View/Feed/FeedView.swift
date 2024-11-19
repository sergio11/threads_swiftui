//
//  FeedView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.threads) { thread in
                        ThreadCell(thread: thread)
                    }
                }
            }
            .refreshable {
                viewModel.fetchThreads()
            }
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.black)
                }
            }
        }.onAppear {
            viewModel.fetchThreads()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
