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
            FeedViewContent(threads: viewModel.threads)
            .refreshable {
                viewModel.fetchThreads()
            }
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fetchThreads()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.black)
                    }
                }
            }.onAppear {
                viewModel.fetchThreads()
            }
            .modifier(LoadingAndErrorOverlayModifier(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage))
        }
    }
}

private struct FeedViewContent: View {
    
    var threads: [ThreadBO]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(threads) { thread in
                    ThreadCell(thread: thread)
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
